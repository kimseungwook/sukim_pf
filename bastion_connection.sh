#!/bin/bash

# =================================================================
# OCI Bastion Session Manager Script v2.6 (Login Function)
# 기능: OCI Bastion 포트 포워딩 세션 생성, 조회, 삭제 및 관리
# 개선: 'login' 명령어 추가로 oci session authenticate 자동화
# =================================================================

# 파이프라인의 명령어 중 하나라도 실패하면 전체를 실패로 간주
set -o pipefail

# OCI Python SDK의 API 키 관련 경고 메시지 비활성화
export SUPPRESS_LABEL_WARNING=True

# --- 구성 정보 ---
# 사용할 OCI CLI 프로필 이름 (기본값, --profile 플래그로 덮어쓰기 가능)
OCI_PROFILE="bastion"
OCI_REGION="ap-seoul-1" # 로그인 및 리전 지정에 사용할 변수

BASTION_OCID="ocid1.bastion.oc1.ap-seoul-1.amaaaaaacgj7s5ya4ar52elr4cp2o55ixi7alje5eh2vpag2uqa3d25klaxq"
DISPLAY_NAME="sukim-pf
TARGET_IP="10.200.10.2"
TARGET_PORT="6443"
LOCAL_PORT="6443"
SSH_PUB_KEY="$HOME/.ssh/oci_bastion.key.pub"
SESSION_TTL="3600"
MAX_WAIT_SECONDS=30

# --- 출력 색상 ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

# --- 로깅 함수 ---
print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }


# --- 의존성 관리 함수 ---
check_and_install_brew_package() {
    local cmd_name="$1"; local pkg_name="$2"
    if command -v "$cmd_name" &> /dev/null; then
        print_success "'$cmd_name'이(가) 이미 설치되어 있습니다."
    else
        print_warning "'$cmd_name'을(를) 찾을 수 없습니다. Homebrew로 자동 설치를 시작합니다..."
        if ! command -v brew &> /dev/null; then
            print_error "Homebrew가 설치되어 있지 않습니다. https://brew.sh/index_ko 에서 설치 후 다시 시도해주세요."; exit 1; fi
        brew install "$pkg_name"
        if [ $? -ne 0 ]; then print_error "'$pkg_name' 설치에 실패했습니다. 스크립트를 종료합니다."; exit 1; fi
        print_success "'$pkg_name' 설치가 완료되었습니다."
    fi
}

check_dependencies() {
    print_status "스크립트 실행에 필요한 프로그램 확인을 시작합니다..."
    if [ ! -f "$HOME/.oci/config" ]; then
        print_warning "OCI 설정 파일(~/.oci/config)을 찾을 수 없습니다."
        print_status "OCI CLI를 처음 사용하는 경우, 'oci setup config' 명령을 실행하여 설정을 먼저 완료해주세요."; exit 1
    else
        print_success "OCI 설정 파일(~/.oci/config)이 존재합니다."
    fi
    if [[ "$(uname -s)" == "Darwin" ]]; then
        check_and_install_brew_package "jq" "jq"; check_and_install_brew_package "oci" "oci-cli"
    else
        if ! command -v jq &> /dev/null; then print_error "'jq'가 설치되어 있지 않습니다. 수동으로 설치해주세요."; exit 1; fi
        if ! command -v oci &> /dev/null; then print_error "'oci-cli'가 설치되어 있지 않습니다. 수동으로 설치해주세요."; exit 1; fi
        print_success "필수 프로그램(jq, oci)이 모두 설치되어 있습니다."
    fi; echo
}

# --- 핵심 기능 함수 ---

# OCI 세션 인증 (로그인)
authenticate_session() {
    local profile_to_use="$1"
    print_status "OCI 세션 인증을 시작합니다 (프로필: $profile_to_use, 리전: $OCI_REGION)..."
    print_warning "웹 브라우저가 열리면 로그인 및 MFA 인증을 완료해주세요."

    oci session authenticate --region "$OCI_REGION" --profile-name "$profile_to_use"

    if [ $? -eq 0 ]; then
        print_success "세션 인증 및 프로필 생성이 성공적으로 완료되었습니다."
        print_status "이제 'create' 명령어를 사용하여 Bastion 세션을 생성할 수 있습니다."
    else
        print_error "세션 인증에 실패했습니다. 다시 시도해주세요."
        return 1
    fi
}

# 세션 생성 및 SSH 터널링 자동 시작
create_session_and_tunnel() {
    local profile_to_use="$1"
    print_status "Bastion 포트 포워딩 세션을 생성 요청합니다 (프로필: $profile_to_use)..."
    
    local ssh_priv_key="${SSH_PUB_KEY%.pub}"
    if [ ! -f "$SSH_PUB_KEY" ] || [ ! -f "$ssh_priv_key" ]; then
        print_error "SSH 공개키/개인키 쌍을 찾을 수 없습니다: $ssh_priv_key / $SSH_PUB_KEY"
        print_warning "아래 명령어를 실행하여 SSH 키를 먼저 생성해주세요."
        echo "ssh-keygen -t rsa -b 4096 -f $ssh_priv_key"
        return 1
    fi

    SESSION_OUTPUT=$(oci --profile "$profile_to_use" --auth security_token bastion session create-port-forwarding \
        --bastion-id "$BASTION_OCID" --ssh-public-key-file "$SSH_PUB_KEY" --target-port "$TARGET_PORT" \
        --target-private-ip "$TARGET_IP" --display-name "$DISPLAY_NAME" --session-ttl "$SESSION_TTL" 2>&1)

    if [ $? -ne 0 ]; then print_error "Bastion 세션 생성 요청에 실패했습니다."; echo "$SESSION_OUTPUT"; return 1; fi
    
    local SESSION_ID=$(echo "$SESSION_OUTPUT" | jq -r '.data.id')
    if [ -z "$SESSION_ID" ] || [ "$SESSION_ID" == "null" ]; then print_error "생성된 세션의 ID를 추출하지 못했습니다."; echo "$SESSION_OUTPUT"; return 1; fi

    print_status "세션이 생성되었습니다. Session OCID: $SESSION_ID"
    print_status "세션이 'ACTIVE' 상태가 될 때까지 확인을 시작합니다 (최대 ${MAX_WAIT_SECONDS}초)..."
    local start_time=$(date +%s)
    
    while true; do
        local current_time=$(date +%s); local elapsed_time=$((current_time - start_time))
        if [ "$elapsed_time" -ge "$MAX_WAIT_SECONDS" ]; then echo; print_error "시간 초과."; get_session_status "$profile_to_use" "$SESSION_ID"; return 1; fi

        local status_output=$(oci --profile "$profile_to_use" --auth security_token bastion session get --session-id "$SESSION_ID" 2>&1)
        local session_status=$(echo "$status_output" | jq -r '.data."lifecycle-state"')

        if [ "$session_status" == "ACTIVE" ]; then
            echo; print_success "Bastion 세션이 성공적으로 활성화되었습니다!"
            echo "SESSION_ID=$SESSION_ID" > .bastion_session_id; print_status "세션 ID가 .bastion_session_id 파일에 저장되었습니다."
            
            local raw_ssh_command=$(echo "$status_output" | jq -r '.data."ssh-metadata".command')
            if [ -z "$raw_ssh_command" ] || [ "$raw_ssh_command" == "null" ]; then print_error "SSH 접속 명령어를 가져오지 못했습니다."; return 1; fi

            local final_ssh_command=$(echo "$raw_ssh_command" | sed "s|<privateKey>|$ssh_priv_key|" | sed "s|<localPort>|$LOCAL_PORT|")
            print_status "자동으로 SSH 터널링을 시작합니다... (종료하려면 Ctrl+C)"
            echo -e "${YELLOW}$final_ssh_command${NC}\n"
            
            eval "$final_ssh_command"
            return 0

        elif [ "$session_status" == "FAILED" ] || [ "$session_status" == "DELETED" ]; then
            echo; print_error "세션이 FAILED 또는 DELETED 상태가 되었습니다."; echo "$status_output" | jq '.'; return 1;
        fi
        
        echo -n "."; sleep 5
    done
}

# 세션 목록 조회
list_sessions() {
    local profile_to_use="$1"
    print_status "모든 Bastion 세션 목록을 조회합니다 (프로필: $profile_to_use)..."
    oci --profile "$profile_to_use" --auth security_token bastion session list \
        --bastion-id "$BASTION_OCID" \
        --all \
        --output table \
        --query 'data[*].{ID:id, Name:"display-name", State:"lifecycle-state", Created:"time-created"}'
}

# 대상 세션 ID 가져오기 (파일 우선)
get_target_session_id() {
    local session_id_arg="$1"
    if [ -n "$session_id_arg" ]; then echo "$session_id_arg"; return; fi
    if [ -f ".bastion_session_id" ]; then grep "SESSION_ID=" .bastion_session_id | cut -d'=' -f2; fi
}

# 세션 상태 조회
get_session_status() {
    local profile_to_use="$1"; local session_id_arg="$2"
    local session_id=$(get_target_session_id "$session_id_arg")
    if [ -z "$session_id" ]; then print_error "조회할 세션 ID가 없습니다."; return 1; fi
    
    print_status "세션 상태를 조회합니다 (프로필: $profile_to_use): $session_id"
    oci --profile "$profile_to_use" --auth security_token bastion session get --session-id "$session_id" | jq '.'
}

# SSH 접속 명령어 조회
get_ssh_command() {
    local profile_to_use="$1"; local session_id_arg="$2"
    local session_id=$(get_target_session_id "$session_id_arg")
    if [ -z "$session_id" ]; then print_error "SSH 명령어를 조회할 세션 ID가 없습니다."; return 1; fi

    print_status "SSH 접속 명령어를 가져옵니다 (프로필: $profile_to_use): $session_id"
    local ssh_priv_key="${SSH_PUB_KEY%.pub}"
    local raw_ssh_command=$(oci --profile "$profile_to_use" --auth security_token bastion session get \
        --session-id "$session_id" --query 'data."ssh-metadata".command' --raw-output 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$raw_ssh_command" ]; then
        local final_ssh_command=$(echo "$raw_ssh_command" | sed "s|<privateKey>|$ssh_priv_key|" | sed "s|<localPort>|$LOCAL_PORT|")
        print_success "아래 명령어를 복사하여 사용하세요:"; echo -e "\n${YELLOW}$final_ssh_command${NC}\n"
    else
        print_error "SSH 명령어를 가져오지 못했습니다. 세션이 'ACTIVE' 상태인지 확인하세요."
    fi
}

# 세션 삭제
delete_session() {
    local profile_to_use="$1"; local session_id_arg="$2"
    local session_id=$(get_target_session_id "$session_id_arg")
    if [ -z "$session_id" ]; then print_error "삭제할 세션 ID가 없습니다."; return 1; fi
    
    print_warning "정말로 세션을 삭제하시겠습니까?: $session_id"
    read -p "진행하려면 'y'를 입력하세요: " -n 1 -r; echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "세션을 삭제합니다 (프로필: $profile_to_use)..."
        oci --profile "$profile_to_use" --auth security_token bastion session delete --session-id "$session_id" --force
        if [ $? -eq 0 ]; then print_success "세션이 성공적으로 삭제되었습니다."; [ -f ".bastion_session_id" ] && rm .bastion_session_id; else print_error "세션 삭제에 실패했습니다."; fi
    else
        print_status "삭제 작업을 취소했습니다."
    fi
}

# 도움말 출력
show_help() {
    echo "OCI Bastion Session Manager"
    echo ""
    echo "사용법: $0 [COMMAND] [SESSION_ID] [--profile PROFILE_NAME]"
    echo ""
    echo "Commands:"
    echo "  login               OCI 세션 토큰을 발급받습니다 (브라우저 인증 필요)."
    echo "  create              새로운 포트 포워딩 세션을 생성하고 자동으로 터널링을 시작합니다."
    echo "  list                모든 Bastion 세션 목록을 조회합니다."
    echo "  status [SESSION_ID] 세션의 상태를 조회합니다 (ID 미입력 시 저장된 세션 사용)."
    echo "  ssh [SESSION_ID]    SSH 접속 명령어를 조회합니다 (ID 미입력 시 저장된 세션 사용)."
    echo "  delete [SESSION_ID] 세션을 삭제합니다 (ID 미입력 시 저장된 세션 사용)."
    echo "  help                이 도움말 메시지를 보여줍니다."
    echo ""
    echo "Options:"
    echo "  --profile [NAME]    사용할 OCI 프로필을 지정합니다. (기본값: $OCI_PROFILE)"
    echo ""
}

# --- 메인 로직 ---
main() {
    check_dependencies
    COMMAND=""; SESSION_ID_ARG=""; PROFILE_OVERRIDE=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --profile) if [ -n "$2" ]; then PROFILE_OVERRIDE="$2"; shift 2; else print_error "--profile 옵션에 이름이 필요합니다."; exit 1; fi;;
            login|create|list|status|ssh|delete|help) if [ -z "$COMMAND" ]; then COMMAND="$1"; else SESSION_ID_ARG="$1"; fi; shift 1;;
            -h|--help) COMMAND="help"; shift 1;;
            *) if [ -z "$SESSION_ID_ARG" ]; then SESSION_ID_ARG="$1"; else print_warning "알 수 없는 인자입니다: $1"; fi; shift 1;;
        esac
    done
    
    local final_profile="$OCI_PROFILE"
    if [ -n "$PROFILE_OVERRIDE" ]; then final_profile="$PROFILE_OVERRIDE"; fi

    case "$COMMAND" in
        login) authenticate_session "$final_profile" ;;
        create) create_session_and_tunnel "$final_profile" ;;
        list) list_sessions "$final_profile" ;;
        status) get_session_status "$final_profile" "$SESSION_ID_ARG" ;;
        ssh) get_ssh_command "$final_profile" "$SESSION_ID_ARG" ;;
        delete) delete_session "$final_profile" "$SESSION_ID_ARG" ;;
        help) show_help ;;
        "") print_error "명령어가 지정되지 않았습니다."; show_help ;;
        *) print_error "알 수 없는 명령어입니다: $COMMAND"; show_help ;;
    esac
}

# 스크립트 실행
main "$@"