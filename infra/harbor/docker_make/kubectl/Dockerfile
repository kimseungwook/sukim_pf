# STAGE 1: kubectl 바이너리를 다운로드하고 검증하는 빌더
FROM alpine:3.22.2 AS builder

# 1. 빌드에 필요한 curl, ca-certificates 설치
RUN apk add --no-cache curl ca-certificates

# 2. 아키텍처 감지 및 kubectl 다운로드/검증
RUN \
  # 현재 머신의 아키텍처 (x86_64 또는 aarch64) 확인
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "aarch64" ]; then \
    K8S_ARCH="arm64"; \
  elif [ "$ARCH" = "x86_64" ]; then \
    K8S_ARCH="amd64"; \
  else \
    echo "Unsupported architecture: $ARCH" >&2; \
    exit 1; \
  fi && \
  echo "Building for $ARCH (Kubernetes arch: $K8S_ARCH)" && \
  \
  # 3. 안정 버전의 kubectl 바이너리와 sha256 체크섬 파일 다운로드
  STABLE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
  echo "Downloading kubectl version ${STABLE_VERSION}" && \
  curl -fLO "https://dl.k8s.io/release/${STABLE_VERSION}/bin/linux/${K8S_ARCH}/kubectl" && \
  curl -fLO "https://dl.k8s.io/release/${STABLE_VERSION}/bin/linux/${K8S_ARCH}/kubectl.sha256" && \
  \
  # 4. 체크섬 검증 (네트워크 오류로 HTML이 다운로드되는 문제 방지)
  echo "Verifying checksum..." && \
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c - && \
  \
  # 5. 실행 권한 부여
  chmod +x kubectl

# --- STAGE 2: 최종 이미지 ---
FROM alpine:3.22.2

# Tekton 스크립트 실행에 필요한 curl과 kubectl을 위해 ca-certificates 설치
RUN apk add --no-cache curl ca-certificates

# 1. builder 스테이지에서 검증된 kubectl 바이너리만 복사
COPY --from=builder /kubectl /usr/local/bin/kubectl

# 2. 설치 확인
RUN echo "kubectl version (client):" && \
    kubectl version --client

# 3. 기본 셸 지정
CMD ["/bin/sh"]