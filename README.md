# OCI 기반 프로덕션 레벨 DevSecOps 플랫폼 구축 프로젝트

## 📖 프로젝트 소개
이 저장소는 **Oracle Cloud Infrastructure (OCI)** 상에서 **Terraform**과 **Kubernetes (OKE)** 를 활용하여 구축한 **프로덕션 레벨의 DevSecOps 플랫폼**입니다. 
인프라 프로비저닝부터 애플리케이션 배포 및 모니터링까지, 현대적인 플랫폼 엔지니어링의 핵심 기술들을 실전과 같은 환경으로 구현하였습니다.

 MSA(Microservices Architecture) 기반의 이커머스 애플리케이션을 운영하기 위한 견고한 인프라와 CI/CD 파이프라인, 그리고 보안 및 관측성(Observability) 시스템을 포함하고 있습니다.

---

## 🏗️ 아키텍처 및 기술 스택

### 1. Infrastructure as Code (IaC) & Cloud
*   **Oracle Cloud Infrastructure (OCI)**: 고가용성 네트워크 구성 (VCN, Subnet, Security List) 및 OKE(Oracle Kubernetes Engine) 클러스터 운영
*   **Terraform**: 모든 인프라 리소스의 코드화 및 모듈화 (`infrastructure/terraform`)

### 2. GitOps & CI/CD
*   **ArgoCD**: Kubernetes 매니페스트 변경 사항을 감지하여 자동 동기화하는 GitOps 구현 (App of Apps 패턴 적용)
*   **Tekton**: Cloud-Native 방식의 CI 파이프라인 구축. Dockerfile 빌드 (Kaniko), 이미지 레지스트리 푸시, 취약점 스캔 자동화
*   **Harbor**: 프라이빗 컨테이너 이미지 레지스트리 및 이미지 취약점 스캔 연동

### 3. Security (DevSecOps)
*   **HashiCorp Vault**: 민감한 정보(Secret)의 중앙 집중식 관리 및 External Secrets Operator(ESO)를 통한 Kubernetes 연동
*   **Kyverno**: Kubernetes 정책 관리 및 파드 보안 표준(PSS) 강제화, Slack 알림 연동
*   **Falco**: 런타임 보안 위협 탐지 및 대응
*   **Trivy**: 컨테이너 이미지 및 파일시스템 취약점 스캔
*   **Authentik**: 통합 인증(SSO) 관리 및 IdP 구성

### 4. Observability (LGTM Stack)
*   **Loki**: 로그 수집 및 집계 (Promtail 활용)
*   **Grafana**: 메트릭, 로그, 트레이싱 데이터 시각화 대시보드 구축
*   **Tempo**: 분산 트레이싱 수집 및 분석
*   **Mimir**: 장기 저장소 기반의 고가용성 Prometheus 메트릭 저장
*   **Prometheus**: 클러스터 및 애플리케이션 메트릭 수집
*   **Uptime Kuma**: 서비스 가용성 모니터링

### 5. Application (E-commerce)
*   **Frontend**: React 기반 웹 애플리케이션
*   **Backend**: Go (Gin framework) 기반 마이크로서비스
*   **Database**: PostgreSQL (CloudNativePG Operator 활용), Redis
*   **Object Storage**: MinIO (이미지 등 정적 자산 저장)

---

## 📂 디렉토리 구조 가이드

이 저장소는 역할과 목적에 따라 체계적으로 구성되어 있습니다.

| 디렉토리 | 설명 |
| --- | --- |
| **`infra`** | Kubernetes 클러스터 위에 배포되는 모든 인프라 애플리케이션(Helm Chart, Manifests)을 포함합니다. (ArgoCD, Vault, Prometheus, etc.) |
| **`application`** | 이커머스 서비스의 소스 코드 및 배포 설정이 위치합니다. (`ecommerce` 디렉토리 내 Frontend/Backend 코드 포함) |
| **`terraform`** | OCI 리소스(VCN, OKE, Compute 등)를 프로비저닝하기 위한 Terraform 코드가 모듈별로 정리되어 있습니다. |
| **`build-pipelines`** | Tekton을 이용한 CI 파이프라인 정의 파일(Task, Pipeline, PipelineRun)들이 저장되어 있습니다. |
| **`deploy-kustomize`** | Kustomize를 활용하여 환경별(Dev, Prod)로 애플리케이션 배포 설정을 관리합니다. |

---

## 🚀 프로젝트 핵심 구현 포인트

1.  **완전한 GitOps 워크플로우**: 코드 변경(`git push`)부터 배포 자동화까지 ArgoCD와 Tekton을 통해 사람의 개입을 최소화했습니다.
2.  **Secret 관리의 현대화**: 하드코딩된 자격 증명을 제거하고 Vault와 ESO를 통해 보안성을 극대화했습니다.
3.  **심층적인 관측성 확보**: 단순 모니터링을 넘어 로그(Loki), 메트릭(Mimir), 트레이싱(Tempo)을 통합하여 장애 원인을 신속하게 파악할 수 있는 환경을 구축했습니다.
4.  **보안 정책 자동화**: Kyverno를 통해 잘못된 설정의 리소스 배포를 차단하고, Falco로 런타임 위협을 실시간으로 감시합니다.
5.  **고가용성 데이터베이스**: CloudNativePG Operator를 사용하여 PostgreSQL의 자동 페일오버 및 백업/복구 전략을 구현했습니다.

---

## 🛠️ 시작하기 (Deployment)

이 프로젝트의 인프라를 배포하려면 Terraform 설정부터 시작해야 합니다.

```bash
# 1. Terraform 초기화 및 적용
cd terraform
terraform init
terraform apply -auto-approve

# 2. ArgoCD 부트스트랩
# Terraform 수행 후 생성된 Kubeconfig를 설정한 뒤 ArgoCD를 배포합니다.
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

*자세한 설치 및 설정 과정은 각 디렉토리의 세부 문서를 참조해주세요.*

---

## 📧 Contact
이 포트폴리오에 대해 궁금한 점이 있으시면 언제든지 연락주세요.
