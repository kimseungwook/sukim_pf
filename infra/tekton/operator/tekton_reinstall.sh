#!/bin/bash

# tekton-complete-cleanup.sh - Tekton 완전 정리 및 재설치 스크립트
# OKE 환경에서 Tekton의 모든 리소스를 깨끗하게 제거하고 재설치

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "========================================"
echo "    Tekton 완전 정리 및 재설치 시작"
echo "========================================"

# 1단계: TektonConfig 및 TektonPipeline 삭제
log_info "1단계: TektonConfig 및 TektonPipeline 삭제 중..."
kubectl delete tektonconfig --all --ignore-not-found=true --timeout=30s || true
kubectl delete tektonpipeline --all --ignore-not-found=true --timeout=30s || true
kubectl delete tektontrigger --all --ignore-not-found=true --timeout=30s || true
kubectl delete tektondashboard --all --ignore-not-found=true --timeout=30s || true
kubectl delete tektoninstallerset --all -A --ignore-not-found=true --timeout=30s || true
log_success "TektonConfig 및 관련 리소스 삭제 완료"

# 2단계: Webhook Configurations 삭제
log_info "2단계: Webhook Configurations 삭제 중..."
kubectl delete validatingwebhookconfigurations --all --ignore-not-found=true || true
kubectl delete mutatingwebhookconfigurations --all --ignore-not-found=true || true
log_success "Webhook Configurations 삭제 완료"

# 3단계: Tekton Namespaces 강제 삭제
log_info "3단계: Tekton Namespaces 강제 삭제 중..."

# tekton-pipelines namespace 강제 정리
if kubectl get namespace tekton-pipelines &>/dev/null; then
    log_info "tekton-pipelines namespace 정리 중..."
    
    # 모든 리소스 강제 삭제
    kubectl delete all --all -n tekton-pipelines --force --grace-period=0 --timeout=30s || true
    kubectl delete configmap --all -n tekton-pipelines --force --grace-period=0 --timeout=30s || true
    kubectl delete secret --all -n tekton-pipelines --force --grace-period=0 --timeout=30s || true
    kubectl delete serviceaccount --all -n tekton-pipelines --force --grace-period=0 --timeout=30s || true
    kubectl delete role --all -n tekton-pipelines --force --grace-period=0 --timeout=30s || true
    kubectl delete rolebinding --all -n tekton-pipelines --force --grace-period=0 --timeout=30s || true
    
    # Finalizer 제거로 namespace 강제 삭제
    kubectl patch namespace tekton-pipelines -p '{"spec":{"finalizers":[]}}' --type=merge || true
    kubectl delete namespace tekton-pipelines --force --grace-period=0 --timeout=30s || true
fi

# 다른 Tekton namespaces도 정리
for ns in tekton-triggers tekton-dashboard; do
    if kubectl get namespace $ns &>/dev/null; then
        log_info "$ns namespace 정리 중..."
        kubectl patch namespace $ns -p '{"spec":{"finalizers":[]}}' --type=merge || true
        kubectl delete namespace $ns --force --grace-period=0 --timeout=30s || true
    fi
done

log_success "Tekton Namespaces 삭제 완료"

# 4단계: Tekton CRDs 삭제
log_info "4단계: Tekton CRDs 삭제 중..."
TEKTON_CRDS=$(kubectl get crd | grep tekton | awk '{print $1}' || true)
if [ ! -z "$TEKTON_CRDS" ]; then
    echo "$TEKTON_CRDS" | xargs kubectl delete crd --ignore-not-found=true --timeout=60s || true
fi

# 개별 CRD들도 확인하여 삭제
CRD_LIST=(
    "clustertasks.tekton.dev"
    "conditions.tekton.dev"
    "customruns.tekton.dev"
    "extensions.dashboard.tekton.dev"
    "pipelineresources.tekton.dev"
    "pipelineruns.tekton.dev"
    "pipelines.tekton.dev"
    "resolutionrequests.resolution.tekton.dev"
    "runs.tekton.dev"
    "stepactions.tekton.dev"
    "taskruns.tekton.dev"
    "tasks.tekton.dev"
    "tektonaddons.operator.tekton.dev"
    "tektonchains.operator.tekton.dev"
    "tektonconfigs.operator.tekton.dev"
    "tektondashboards.operator.tekton.dev"
    "tektonhubs.operator.tekton.dev"
    "tektoninstallersets.operator.tekton.dev"
    "tektonpipelines.operator.tekton.dev"
    "tektonresults.operator.tekton.dev"
    "tektontriggers.operator.tekton.dev"
    "verificationpolicies.tekton.dev"
)

for crd in "${CRD_LIST[@]}"; do
    kubectl delete crd $crd --ignore-not-found=true --timeout=30s || true
done

log_success "Tekton CRDs 삭제 완료"

# 5단계: ClusterRole 및 ClusterRoleBinding 삭제
log_info "5단계: Tekton ClusterRole 및 ClusterRoleBinding 삭제 중..."
kubectl delete clusterrole,clusterrolebinding -l app.kubernetes.io/part-of=tekton-operator --ignore-not-found=true || true
kubectl delete clusterrole,clusterrolebinding -l app.kubernetes.io/part-of=tekton-pipelines --ignore-not-found=true || true
kubectl delete clusterrole,clusterrolebinding -l app.kubernetes.io/part-of=tekton-triggers --ignore-not-found=true || true

# 개별적으로도 삭제 시도
TEKTON_CLUSTER_RESOURCES=$(kubectl get clusterrole,clusterrolebinding | grep tekton | awk '{print $1}' || true)
if [ ! -z "$TEKTON_CLUSTER_RESOURCES" ]; then
    echo "$TEKTON_CLUSTER_RESOURCES" | xargs kubectl delete --ignore-not-found=true || true
fi

log_success "ClusterRole 및 ClusterRoleBinding 삭제 완료"

# 6단계: Tekton Operator 삭제
log_info "6단계: Tekton Operator 삭제 중..."
kubectl delete -f https://storage.googleapis.com/tekton-releases/operator/latest/release.yaml --ignore-not-found=true --timeout=60s || true

# tekton-operator namespace 강제 삭제
if kubectl get namespace tekton-operator &>/dev/null; then
    kubectl delete all --all -n tekton-operator --force --grace-period=0 --timeout=30s || true
    kubectl patch namespace tekton-operator -p '{"spec":{"finalizers":[]}}' --type=merge || true
    kubectl delete namespace tekton-operator --force --grace-period=0 --timeout=30s || true
fi

log_success "Tekton Operator 삭제 완료"

# 7단계: 정리 확인
log_info "7단계: 정리 상태 확인 중..."
sleep 10

# 남은 리소스 확인
echo "=== 남은 Tekton 관련 리소스 확인 ==="
echo "Namespaces:"
kubectl get namespace | grep tekton || echo "  Tekton namespaces 없음"
echo ""
echo "CRDs:"
kubectl get crd | grep tekton || echo "  Tekton CRDs 없음"
echo ""
echo "ClusterRoles:"
kubectl get clusterrole | grep tekton || echo "  Tekton ClusterRoles 없음"
echo ""
echo "Webhook Configurations:"
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | grep tekton || echo "  Tekton Webhooks 없음"

log_success "정리 완료!"

# 8단계: 재설치 시작
log_info "8단계: Tekton Operator 재설치 시작..."
sleep 30

log_info "Tekton Operator 설치 중..."
kubectl apply -f https://storage.googleapis.com/tekton-releases/operator/latest/release.yaml

log_info "Tekton Operator 준비 대기 중..."
kubectl wait --for=condition=available --timeout=300s deployment/tekton-operator -n tekton-operator

log_success "Tekton Operator 설치 완료!"

# 9단계: TektonConfig 생성
log_info "9단계: TektonConfig 생성 중..."
kubectl apply -f - <<EOF
apiVersion: operator.tekton.dev/v1alpha1
kind: TektonConfig
metadata:
  name: config
spec:
  profile: lite
  targetNamespace: tekton-pipelines
  config:
    feature-flags:
      disable-creds-init: true
      disable-affinity-assistant: true
    pipeline:
      require-git-ssh-secret-known-hosts: false
EOF

log_success "TektonConfig 생성 완료!"

# 10단계: 설치 진행 상황 모니터링
log_info "10단계: 설치 진행 상황 모니터링..."
echo ""
echo "=== 설치 진행 상황 ==="
echo "다음 명령어로 진행 상황을 확인할 수 있습니다:"
echo ""
echo "TektonConfig 상태 확인:"
echo "  kubectl get tektonconfig config -o jsonpath='{.status.conditions[?(@.type==\"Ready\")].status}'"
echo ""
echo "Tekton Pipelines 포드 상태 확인:"
echo "  kubectl get pods -n tekton-pipelines"
echo ""
echo "실시간 모니터링:"
echo "  watch -n 5 'kubectl get tektonconfig config && echo && kubectl get pods -n tekton-pipelines'"
echo ""

# 초기 상태 표시
echo "현재 TektonConfig 상태:"
kubectl get tektonconfig config 2>/dev/null || echo "  아직 생성 중..."
echo ""

log_info "설치가 완료되려면 약 5-10분 정도 소요됩니다."
log_info "설치 완료 후 모든 포드가 Running 상태가 되어야 합니다."

echo ""
echo "========================================"
echo "    Tekton 정리 및 재설치 완료"
echo "========================================"