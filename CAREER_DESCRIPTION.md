# 경력 기술서 (Career Description)

## Professional Summary

15년간의 Backend 개발 경력(Spring Boot, Kotlin, Java)을 기반으로 4년이 넘는 기간동안 DevOps/Infrastructure 전문가로 전환하여 Multi-Cloud 환경에서 복잡한 인프라를 설계하고 운영해왔습니다. **현재 30 Nodes, 559 Pods 규모의 Production Kubernetes와 H100 8-GPU AI 인프라를 1인 체제로 안정 운영** 중이며, **모든 프로젝트에서 AWS, Azure, OCI 전체 인프라를 Terraform으로 관리하고, GitOps(ArgoCD + Kustomize) 기반으로 애플리케이션을 배포**한 경험을 보유하고 있습니다.

**Core Competencies**
- Infrastructure as Code (Terraform 기반 AWS, Azure, OCI, GCP 전체 인프라 관리)
- GitOps & Declarative Configuration (ArgoCD + Kustomize)
- CI/CD Automation (Tekton Helm Chart, GitHub Webhook)
- Kubernetes Production Operations (30 Nodes, 559 Pods, 30 Namespaces)
- AI/ML Infrastructure (H100 8-GPU Monitoring, LLM Ops, Vector DB)
- Hybrid Network Design (Site-to-Site VPN, Cloud Interconnect)
- Security & Compliance (ISO 27001, ISO 27701, ISO 42001, ISMS-P 인증 기술 주도)
- Enterprise Blockchain (Hyperledger Besu)
- Backend Development (Java, JSP, ASP, Oracle, MySQL, MS SQL Server - 15년)

## 1. 프로젝트: AI Agent 서비스 플랫폼 구축 및 국제 표준 인증 대응

**기간**: 2022.12 ~ 2024.12
**소속**: 유클릭
**역할**: DevOps Engineer / Infrastructure Architect  
**운영 규모**: 
- Kubernetes: 30 Nodes, 30 Namespaces, 185 Workloads, 559 Pods
- AI Infrastructure: On-Premise GPU Server (H100 8-GPU)

**기술 스택**:
- Infrastructure as Code: Terraform (AWS, Azure, OCI 전체 인프라 관리)
- GitOps: ArgoCD + Kustomize (애플리케이션 배포)
- CI/CD: Tekton (Helm Chart 기반 Pipeline/Task 구성)
- Cloud & Infrastructure: OCI (OKE), Azure (AKS), On-Premise GPU (H100 x8)
- Network: OCI FastConnect, Azure ExpressRoute, Site-to-Site VPN (Fortigate UTM)
- Ingress: Traefik LoadBalancer (YAML)
- Container Registry: Harbor
- AI Operations: DCGM Exporter, Prometheus Operator, Langfuse, LangChain
- Database: OCI Managed PostgreSQL (pgvector), ChromaDB
- Security & Compliance: ISO 27001, ISO 27701, ISO 42001, ISMS-P, Vault, Falco, Kyverno
- Monitoring: Prometheus, Grafana, Loki, Tempo, Mimir

### 주요 성과

#### 국제 표준 인증 및 AI 보안 아키텍처

**ISO 27001 (정보보안 경영시스템)**
- 기술적 보호조치 구현 및 증적 자료 작성
- 정보자산 관리, 접근 통제, 암호화 정책 수립
- 기술 검증

**ISO 27701 (개인정보보호 경영시스템)**
- GDPR 및 개인정보보호법 준수 체계 구축
- 개인정보 생명주기 관리 (수집, 처리, 저장, 폐기)
- 데이터 주체 권리 보장을 위한 기술적 조치
- 개인정보 영향평가(PIA) 대응

**ISO 42001 (AI 경영시스템) - 2023년 12월 제정**
- **국내 최초 수준 AI 서비스 인증 대응**
- AI 시스템 위험 관리 체계 구축
  - AI 모델 학습 데이터 관리 (Data Governance)
  - AI 편향성(Bias) 모니터링 및 공정성 검증
  - AI 의사결정 투명성 및 설명가능성(Explainability)
- AI 윤리 원칙 구현
  - 프라이버시 보호 (Federated Learning 고려)
  - AI 출력 모니터링 및 유해 콘텐츠 필터링
- LLM 서비스 특화 보안 조치
  - Prompt Injection 방어
  - 토큰 사용량 제한 및 비용 관리 (Langfuse)
  - API 키 안전 관리 (k8s secret)
  - 개인정보 비식별화 처리

**ISMS-P (국내 정보보호 및 개인정보보호 관리체계)**
- 기술적 보호조치 30+ 항목 구현
- 예비 심사 통과 및 본 심사 진행 중 (2025.01 인증 예정)

**DevSecOps 자동화**
- Vault: Secret Zero Trust 관리, AI API Key 안전 저장
- Falco: Runtime Security, 컨테이너 이상 행위 탐지
- Kyverno: Policy as Code, Pod Security Standards 강제
- Kustomize로 30개 Namespaces 통합 보안 정책 배포
  - NetworkPolicy: Namespace 간 통신 제어
  - PodSecurityPolicy: 컨테이너 권한 제한
  - Resource Quota: 리소스 사용량 제한

#### Infrastructure as Code (Terraform)

**전체 인프라 코드 관리**
- **OCI 인프라 전체 Terraform 관리**
  - VCN, Subnet, Security List, Route Table, NAT Gateway, Internet Gateway
  - OKE Cluster, Node Pool (Regular, Virtual Node), Autoscaling 설정
  - VPN Gateway, FastConnect, DRG (Dynamic Routing Gateway)
  - Managed PostgreSQL, Object Storage, Block Volume
  - Load Balancer, Network Security Group
  
- **Azure 인프라 전체 Terraform 관리**
  - VNet, Subnet, Network Security Group, Route Table
  - AKS Cluster, Node Pool, Autoscaling 설정
  - ExpressRoute, VPN Gateway
  - Container Registry (ACR), Storage Account
  - Azure Monitor, Log Analytics Workspace

- **Hybrid Cloud Interconnect Terraform 구성**
  - OCI FastConnect ↔ Azure ExpressRoute Peering
  - 프라이빗 통신 터널 자동 프로비저닝
  - BGP 라우팅 설정 자동화

- **On-Premise VPN Terraform 관리**
  - OCI VPN Gateway 프로비저닝
  - Fortigate UTM과의 Site-to-Site IPsec VPN 연결
  - 라우팅 테이블 및 Security Rule 자동 구성

**Terraform 운영 방식**
- **Workspace 분리**: Dev, Staging, Prod 환경별 독립 관리
- **Module 설계**: VPC, K8s Cluster, VPN 등 재사용 가능한 모듈 구성
- **변경 관리**: Terraform Plan → 코드 리뷰 → Apply 워크플로우
- **Drift Detection**: 수동 변경 감지 및 자동 복구

#### GitOps & CI/CD

**GitOps 구성 (ArgoCD + Kustomize)**
- ArgoCD + Kustomize로 185 Workloads 애플리케이션 배포 관리
- Git Push → ArgoCD 자동 감지 → Pod 배포
- Kustomize Base/Overlay로 환경별 설정 분리
  - Base: 공통 Deployment, Service, ConfigMap
  - Overlay: 환경별 리소스, 이미지 태그, 환경 변수
- App of Apps 패턴으로 30개 Namespace 통합 관리
- Self-Healing: 클러스터 Drift 자동 복구
- Rollback: Git Revert로 즉시 이전 버전 복구

**CI/CD 구성 (Tekton + Helm)**
- Tekton Pipeline, Task, Trigger를 Helm Chart로 관리
  - Pipeline: Git Clone → Kaniko Build → Manifest Update
  - Task: 모듈별 빌드 작업 (Gradle, Dockerfile 동적 선택)
  - Trigger: GitHub Webhook 자동 빌드 연동
- Helm values.yaml로 환경별 설정 중앙화
  - Container Registry URL, Slack Webhook
  - Node Selector, Tolerations (빌드 전용 노드)
- Kaniko: Docker-in-Docker 없이 안전한 컨테이너 빌드
- Harbor Private Registry 연동

#### Multi-Cloud Strategy & FinOps

**문제 상황**
- Azure 기반 초기 구성 시 OCI 대비 2.2~2.3배 높은 비용 발생
- 월 예산 대비 운영 비용 초과 우려

**해결 방안**
- Terraform으로 Azure와 OCI Hybrid 아키텍처 구현
  - Azure: Frontend, Backend API, Harbor (ACR)
  - OCI: Tekton CI/CD, Managed PostgreSQL (pgvector)
- Terraform으로 FastConnect ↔ ExpressRoute 자동 프로비저닝
- Terraform 코드로 비용 시뮬레이션 수행
  - 동일 워크로드를 Azure/OCI Terraform 코드로 각각 구성
  - 월별 예상 비용 비교 분석

**결과**
- 경영진 보고 및 OCI 단일 클라우드 통합 의사결정 주도
- 월 운영 비용 50% 이상 절감
- Terraform으로 무중단 마이그레이션 완료 (Azure → OCI)
- 인프라 코드 재사용으로 향후 멀티 클라우드 전환 용이성 확보

#### Production Kubernetes Operations

**운영 현황**
- 30 Nodes, 30 Namespaces, 185 Workloads, 559 Pods 운영
- 주 1회 정기 배포 (GitOps 기반 무중단 배포)
- ArgoCD로 배포 자동화 및 즉시 Rollback 체계
- Traefik LoadBalancer (YAML) 기반 통합 Ingress 관리

**자동화 수준**
- Terraform: 인프라 변경 자동화
- ArgoCD: 애플리케이션 배포 자동화
- Tekton: 빌드 및 이미지 푸시 자동화
- Kustomize: 환경별 설정 자동 적용
- Self-Healing: 클러스터 상태 자동 복구

#### Hybrid AI Infrastructure & GPU Observability

**구축 내용**
- **Terraform으로 Hybrid 네트워크 구성**
  - OCI OKE Cluster, VPN Gateway 프로비저닝
  - On-Premise ↔ OCI Site-to-Site VPN 자동 구성
  - Fortigate UTM 설정과 연동되는 VPN 터널
  
- **GPU 모니터링 파이프라인**
  - DCGM Exporter 배포: H100 8-GPU 전체 메트릭 수집
  - Prometheus Operator: VPN을 통한 30초 단위 Pull
  - GPU별 온도, 전력, 사용률, 메모리, NVLink 대역폭 모니터링
  - Grafana Dashboard: 8-GPU 실시간 시각화 및 Slack 알림
  - 고가 AI 인프라($250K+) 장애 예방 및 리소스 최적 배분

- **Vector DB 전환**
  - ChromaDB → OCI Managed PostgreSQL (pgvector)
  - Terraform으로 PostgreSQL 인스턴스 프로비저닝
  
- **LLM Observability (ISO 42001 대응)**
  - Langfuse: 토큰 사용량, API 비용, 지연시간 모니터링
  - AI 모델 버전 추적 및 입출력 로깅
  - Prompt Injection 시도 탐지 및 차단
  - 개인정보 포함 여부 자동 검사

#### 네트워크 및 Kubernetes 구성

- **Terraform으로 관리**
  - OCI-Azure FastConnect/ExpressRoute
  - On-Premise ↔ OCI VPN Gateway
  - Security List, Route Table, NAT Gateway
  
- **YAML/GitOps로 관리**
  - Traefik LoadBalancer: 30개 Namespace Ingress
  - ArgoCD + Kustomize: 185 Workloads 배포
  - Tekton (Helm): CI/CD Pipeline

---

## 2. 프로젝트: 국내 최초 STO 부동산 조각투자 플랫폼 인프라 구축 및 ISMS 인증

**기간**: 2021.10 ~ 2022.12
**소속**: 비브릭
**역할**: DevOps Engineer  
**기술 스택**:
- Infrastructure as Code: Terraform (AWS 전체 인프라 관리)
- Cloud & Infrastructure: AWS (VPC, EC2, RDS, ECS Fargate, WorkSpaces, SSM)
- Network: VPN Site-to-Site (Fortigate UTM ↔ AWS VPC)
- CI/CD: Jenkins (Master-Slave on ECS Fargate), Elastic Beanstalk, SonarQube
- Security & Compliance: ISMS 인증, 망 분리, IAM Policy

### 주요 성과

#### Infrastructure as Code (Terraform)

**AWS 인프라 0 to 1 구축**
- **Terraform으로 전체 AWS 인프라 프로비저닝**
  - VPC (3-Tier Architecture): Public, Private, DB Subnet
  - Route Table, Internet Gateway, NAT Gateway
  - Security Group, NACL (최소 권한 원칙)
  - EC2, Auto Scaling Group
  - RDS MySQL Multi-AZ
  - Elastic Beanstalk Environment
  - ECS Fargate Cluster (Jenkins Master-Slave)
  - AWS WorkSpaces (VDI 환경)
  - VPN Gateway (Fortigate UTM 연결)

- **Terraform State 관리**
  - S3 Backend + DynamoDB Lock
  - 환경별 Workspace 분리
  - 변경 이력 추적 가능

- **Terraform Module 설계**
  - VPC Module: 재사용 가능한 네트워크 구성
  - RDS Module: Multi-AZ, Backup, Monitoring 포함
  - Security Module: Security Group, IAM Role

#### ISMS 인증 (국내 최초 STO 분야)

**배경**
- 금융위원회 STO 규제 샌드박스 승인 조건으로 ISMS 인증 필수

**구현 내용**
- 기술적 보호조치 30+ 항목 Terraform 코드로 구현
- **논리적 망 분리**: Terraform으로 AWS WorkSpaces VDI 환경 구축
  - Private Subnet에만 RDS, EC2 접근 허용
  - WorkSpaces를 통해서만 내부망 접근
- **Keyless 접속**: Session Manager 도입
  - SSH 키 파일 관리 위험 제거
  - IAM Policy 기반 세션 로깅
  - CloudWatch Logs 중앙 집중화

**결과**
- 1회 심사 통과 및 ISMS 인증 획득
- 정식 서비스 런칭 기여
- Terraform 코드로 인증 요건 재현 가능

#### Serverless CI/CD Pipeline

**Jenkins on ECS Fargate**
- Terraform으로 ECS Fargate Cluster 프로비저닝
- Master-Slave 구조: 빌드 시에만 동적 Task 생성
- Gradle 병렬 빌드로 배포 시간 15분 → 8분 단축

**DevSecOps**
- SonarQube Quality Gate
  - 커버리지 70% 이상
  - Critical/Blocker 이슈 0건
- SAST 자동화

---

## 3. 프로젝트: Hyperledger Besu 기반 Private Blockchain 플랫폼 구축 (PoC)

**기간**: 2022.12 ~ 2023.08
**소속**: 비브릭
**역할**: DevOps Engineer  
**기술 스택**:
- Infrastructure as Code: Terraform (AWS 전체 인프라 관리)
- GitOps: ArgoCD + Kustomize (Blockchain Node 배포)
- Blockchain: Hyperledger Besu (Private Ethereum), QBFT Consensus, Blockscout
- Cloud & Infrastructure: AWS (VPC, EC2, EKS)
- Network: VPN Site-to-Site (Fortigate UTM ↔ AWS VPC)
- Container: Kubernetes (EKS), Traefik IngressRoute
- Application: Kotlin Spring Boot, Truffle, Web3j

### 주요 성과

**프로젝트 개요**
- 기업 내부 Smart Contract 실행 환경 PoC 구축
- 인프라 구축 완료 후 운영 단계로 미진행

#### Infrastructure as Code (Terraform)

**AWS 인프라 전체 Terraform 관리**
- **네트워크 인프라**
  - VPC, Subnet (Public/Private), Route Table
  - Internet Gateway, NAT Gateway
  - Security Group (VPN 대역에서만 P2P, RPC 허용)
  - VPN Gateway (Fortigate UTM 연결)

- **컴퓨팅 인프라**
  - Dev: EC2 인스턴스 (단일 Validator Node)
  - Prod: EKS Cluster, Node Group (3-Node Validator)
  - Auto Scaling Group

- **IAM 및 보안**
  - IAM Role, Policy (EKS, EC2)
  - Security Group, NACL
  - KMS Key (암호화)

#### GitOps & Blockchain

**GitOps 구성 (ArgoCD + Kustomize)**
- Besu Validator Node 3대 배포
- Blockscout Explorer 배포
- Kustomize로 환경별 설정 분리
  - Base: Besu Genesis, Config
  - Overlay: Dev (EC2), Prod (EKS)

**Private Blockchain 선택 배경**
- 트랜잭션 비공개 (Privacy)
- 가스비 없는 무료 처리
- Permissioned Network (보안 강화)
- 빠른 Finality (QBFT: <2초)
- EVM 호환성 (Solidity)

#### Hybrid Network 설계

**Terraform으로 VPN 구성**
- AWS VPN Gateway 프로비저닝
- Fortigate UTM ↔ AWS VPC Site-to-Site IPsec VPN
- 라우팅 테이블 자동 업데이트
- 사내망에서 Private Blockchain Node 직접 접근

**보안 설계**
- Validator Node Private Subnet 배치
- Security Group: VPN 대역만 허용
  - 30303 (P2P)
  - 8545 (RPC)
- Bastion Host 미사용 (Attack Surface 최소화)

**프로젝트 성과**
- Terraform + GitOps 기반 Blockchain 인프라 구축 경험
- IaC로 재현 가능한 환경 구성
- QBFT 합의: 블록 생성 <2초 (Public Ethereum 대비 6배 향상)

---

## 4. 프로젝트: IoT 태양광 발전 데이터 수집 플랫폼 (PoC)

**기간**: 2023.08 ~ 2023.12
**소속**: 비브릭
**역할**: Infrastructure Engineer  
**기술 스택**:
- Infrastructure as Code: Terraform (AWS 전체 인프라 관리)
- GitOps: ArgoCD + Kustomize (Kafka Ecosystem 배포)
- Cloud & Infrastructure: AWS EKS, S3, Glue, Athena
- Data Streaming: Kafka, Kafka Connect, Schema Registry, KSQL
- Container: Kubernetes (EKS), Traefik IngressRoute, Tekton, Harbor
- Authentication: Authentik SSO
- Monitoring: Prometheus, Grafana,Loki,Tempo, Mimir, Kafka Exporter

### 주요 성과

**프로젝트 개요**
- 태양광 모듈 실시간 데이터 수집 및 분석 플랫폼 PoC 구축
- 인프라 구축 완료 후 사업 방향 변경으로 프로덕션 미운영

#### Infrastructure as Code (Terraform)

**AWS 인프라 전체 Terraform 관리**
- **Kubernetes 인프라**
  - EKS Cluster, Node Group
  - VPC, Subnet, Security Group
  - Auto Scaling, Cluster Autoscaler

- **Data Lake 인프라**
  - S3 Bucket (Data Lake Storage)
  - AWS Glue Catalog, Crawler
  - Athena Workgroup
  - IAM Role (Least Privilege)

- **네트워크 및 보안**
  - VPC Endpoint (S3, Glue)
  - Security Group, NACL
  - CloudWatch Logs

#### GitOps & Event-Driven Architecture

**GitOps 구성 (ArgoCD + Kustomize)**
- Kafka 3-Broker Cluster 배포
- Schema Registry, KSQL, Kafka Connect 배포
- Kustomize로 Dev/Prod 설정 분리

**Kafka Ecosystem**
- 3-Broker Cluster (RF=3, Min ISR=2)
- Schema Registry: Avro 스키마 버저닝
- KSQL: 실시간 스트림 집계 (5분 윈도우)
- Kafka Connect S3 Sink: 자동 데이터 적재

**Serverless Data Lake Pipeline**
- Terraform으로 S3, Glue, Athena 프로비저닝
- Ingestion: Kafka → S3 (Parquet)
- Cataloging: Glue Crawler 자동 스키마 추출
- Query: Athena SQL 기반 Ad-hoc 분석

#### Kubernetes 플랫폼 운영

**Ingress & Auth**
- Traefik LoadBalancer (YAML)
- Authentik SSO: Kafka UI, Schema Registry UI

**Monitoring**
- Prometheus + Kafka Exporter
- Grafana: Cluster 상태, Topic 처리량
- Alertmanager: Consumer Lag → Slack

**프로젝트 성과**
- Terraform + GitOps 기반 Data Platform 구축
- IaC로 재현 가능한 Kafka Ecosystem

---

## 5. 프로젝트: 경영 데이터 분석 플랫폼 'Hyper Report' 구축 및 GCP 이관

**기간**: 2023.12 ~ 2024.12 (약 1년 운영)
**소속**: 유클릭
**역할**: DevOps Engineer  
**기술 스택**:
- Phase 1 (OCI): Terraform, ArgoCD + Kustomize, Chaos Mesh, KEDA, VPA, Goldilocks, Descheduler
- Network: VPN Site-to-Site (Fortigate UTM ↔ OCI)
- Container: OKE, Traefik IngressRoute, Tekton, Authentik
- Monitoring: Prometheus, Grafana, Loki, Tempo, Mimir
- Phase 2 (GCP): Terraform, Makefile

### 주요 성과

**프로젝트 배경**
- On-Premise → Cloud 전환
- 약 1년 운영 후 사업 방향 변경으로 GCP 환경 이관

#### Infrastructure as Code (Terraform)

**OCI 인프라 전체 Terraform 관리**
- VCN, Subnet, Route Table, Security List
- OKE Cluster, Node Pool
- VPN Gateway (Fortigate UTM 연결)
- Object Storage, Block Volume

**GCP 인프라 Terraform 관리**
- App Engine Standard Environment
- Cloud SQL (Managed MySQL)
- VPC, Firewall Rules
- IAM Service Account

#### Advanced Kubernetes Operations (OCI OKE)

**Resiliency & Autoscaling**
- Chaos Mesh: Pod Kill, Network Delay, I/O Fault 테스트
- KEDA: Kafka Consumer Lag 기반 Event-driven Autoscaling
- VPA: 실제 사용량 기반 리소스 자동 조정
- Goldilocks: Right-Sizing 추천

**Resource Optimization**
- Descheduler: 노드 간 Pod 재분배
- Cluster Autoscaler + VPA: 노드 20% 절감

**Hybrid Network**
- Terraform으로 OCI VPN Gateway 프로비저닝
- Fortigate UTM ↔ OCI VPN 연결

#### Cloud Migration (OCI → GCP)

**이관 전략**
- Terraform으로 GCP 인프라 프로비저닝
- Kubernetes → PaaS 전환 (관리 부담 최소화)
- App Engine + Cloud SQL
- Makefile 기반 배포 스크립트
- 기술 문서화 및 개발팀 인수인계

**프로젝트 성과**
- Terraform 기반 Multi-Cloud 마이그레이션 경험
- OCI → GCP 무중단 이관
- IaC로 인프라 재현성 확보

## 6. 프로젝트: 온라인 임용고시 교육 플랫폼 개발 및 부분 클라우드 전환

**기간**: 2013.10 ~ 2021.07 (7년 10개월)  
**소속**: 와이에스디  
**역할**: Backend Developer / Infrastructure Engineer  

**기술 스택**:
- **On-Premise Infrastructure**: Windows Server 10대, CentOS 2대, NAS Storage 2대
- **Application**: Java, JSP, Tomcat, MS SQL Server
- **Video Streaming**: Wowza Streaming Engine (NAS 기반)
- **Partial Cloud Migration (2020.09)**: AWS ECS Fargate, Docker, MongoDB

### 주요 성과

#### 국내 Top3 임용고시 플랫폼 Backend 개발 및 인프라 운영

**서비스 개요**
- 온라인 임용고시 동영상 강의 플랫폼 (국내 시장 Top3)
- 수천 개 동영상 콘텐츠 스트리밍 서비스
- 피크 시즌(시험 대비 기간) 트래픽 급증 대응

**Backend 개발**
- Java JSP 기반 온라인 강의 플랫폼 개발 및 운영
- MS SQL Server 스키마 설계 및 데이터베이스 성능 튜닝
  - 인덱스 최적화 및 쿼리 개선
  - 응답 시간 단축으로 사용자 경험 향상
- 동영상 메타데이터 관리 시스템 구축

**On-Premise 인프라 운영 (2013~2021)**
- **서버 관리**: Windows Server 10대, CentOS 2대 직접 운영
  - Windows Server: Tomcat 기반 Java JSP 애플리케이션 배포
  - MS SQL Server 데이터베이스 관리
  - CentOS: 운영 도구 및 배치 작업
- **스토리지**: NAS Storage 2대 운영
- **동영상 스트리밍 인프라**
  - Wowza Streaming Engine 구축 및 운영
  - 촬영 편집자 실시간 확인 → NAS 저장 파이프라인
  - 실시간 인코딩 및 스트리밍 서비스

#### 성능 병목 해결: 동영상 재생 부분 AWS 분리 (2020.09)

**문제 상황**
- 피크 타임(시험 시즌) 동영상 재생 요청 폭증
- 초당 1,000건 이상의 재생 로그 처리로 서버 과부하
- 동영상 재생 실패 및 메인 서비스 접속 오류 발생

**해결 방안**
- **선택적 클라우드 분리 전략**
  - 메인 서비스(강의 목록, 결제, 회원 관리): On-Premise 유지
  - **동영상 재생 부분만** AWS로 분리
- **AWS 아키텍처**
  - ECS Fargate: Docker 컨테이너 기반 동영상 플레이어 서비스
  - MongoDB: 동영상 재생 로그 및 메타데이터 저장
  - Auto Scaling: 트래픽에 따른 자동 확장

**결과**
- **서버 다운 제로**: 피크 타임에도 안정적 서비스 제공
- **메인 서비스 안정성 확보**: 동영상 재생 부하 분리로 전체 시스템 안정화
- **Hybrid 아키텍처 경험**: On-Premise ↔ AWS 연동 운영

**DevOps 전환의 시작점**
- On-Premise 서버 관리 경험 (Windows Server, CentOS, NAS)
- 클라우드 컨테이너 기술 도입 (Docker, ECS Fargate)
- 성능 문제 해결을 위한 아키텍처 전환 주도

---

## 7. 프로젝트: 모바일 위치정보 서비스 플랫폼 개발

**기간**: 2010.08 ~ 2013.08 (3년 1개월)  
**소속**: 아로정보기술  
**역할**: Backend Developer / Mobile Application Developer  

**기술 스택**:
- **Backend**: Java, JSP, Tomcat
- **Mobile**: WAP (WML + JSP), Android (Java)
- **Integration**: NFC API, Google Maps API

### 주요 성과

#### SKT Nate 위치정보 서비스 개발 (WAP)

**서비스 개요**
- SKT WAP 기반 위치정보 제공 서비스
- 실시간 교통정보, 대중교통 노선 안내, 내 주변 맛집 검색

**기술 구현**
- Java JSP + Tomcat 기반 Backend API 개발
- WML 정적 코드 + JSP include 방식으로 WAP 페이지 구성
- Google Maps API 연동을 통한 위치정보 제공

#### 중앙농협 NFC 교통카드 잔액조회 APP 개발 (Android)

**프로젝트 개요**
- 안드로이드 기반 티머니/캐시비 NFC 잔액체크 애플리케이션
- Google Play 퍼블릭 배포

**담당 역할**
- Android Application 개발 (Java)
- Backend API 개발 및 NFC 업체 API 연동
- NFC 카드 리더 통신 및 잔액 정보 파싱

#### 안드로이드 대중교통 APP 개발

- 실시간 버스/지하철 도착 정보 제공
- Google Maps 기반 경로 안내
- Backend API 설계 및 개발

---

## 8. 프로젝트: 통신사 WAP 개발

**기간**: 2008.09 ~ 2010.06 (1년 10개월)  
**소속**: 포엠데이타  
**역할**: iOS Developer / Backend Developer  

**기술 스택**:
- **iOS**: Objective-C
- **Backend**: ASP, MS SQL Server

### 주요 성과

#### SKT/KT/LGT WAP 개발

**프로젝트 개요**
- 통신 3사(SKT, KT, LGT) WAP 기반 서비스

**기술 구현**
- ASP + MS SQL Server 기반 Backend 개발
- WAP 페이지 개발 및 이미지 콘텐츠 관리

#### iOS 화보페이지 개발

- Objective-C 기반 iOS 애플리케이션 개발
- 갤러리 UI 구현

---

## 9. 프로젝트: SKT 음성문자 서비스 개발

**기간**: 2008.01 ~ 2008.09 (9개월)  
**소속**: 킨모바일  
**역할**: Backend Developer  

**기술 스택**: ASP, Mysql

### 주요 성과

- 통신 3사(SKT, KT, LGT) WAP 기반 서비스

---

## 10. 프로젝트: 음성 TTS 서비스 개발

**기간**: 2007.11 ~ 2008.02 (4개월)  
**소속**: 모엔트  
**역할**: Backend Developer  

**기술 스택**: JSP, Java, Oracle

### 주요 성과

- 음성 TTS(Text-to-Speech) 서비스 Backend 개발
- JSP, Java, Oracle 기반 서비스 구현

---

## 11. 프로젝트: 피처폰 VM 서비스 개발

**기간**: 2006.07 ~ 2007.10 (1년 4개월)  
**소속**: 콜바다  
**역할**: Mobile Application Developer / Backend Developer  

**기술 스택**:
- **Mobile VM**: WIPI Jlet, Brew
- **Backend**: JSP, Java, Oracle

### 주요 성과

#### KT 키즈랜드 VM 서비스 개발

**프로젝트 개요**
- 피처폰용 가상머신(VM) 기반 키즈 콘텐츠 서비스

**기술 구현**
- WIPI Jlet 기반 피처폰 애플리케이션 개발
- Brew 플랫폼 개발
- ME/KUN 규격 기반 서비스 제공

#### KT 통화배경음 서비스 유지보수 및 신규 개발

**담당 업무**
- JSP, Java, Oracle 기반 Backend 개발 및 운영
- ME/KUN 규격 기반 피처폰 서비스 연동
- 기존 서비스 유지보수 및 신규 기능 개발

---

# 전체 경력 통합 요약

## 기술 역량 (Technical Skills)

### Infrastructure as Code
- **Terraform**: AWS, Azure, OCI, GCP 전체 인프라 관리
- **State Management**: S3 Backend, DynamoDB Lock, Workspace
- **Module Design**: 재사용 가능한 VPC, K8s, Database 모듈
- **Multi-Cloud**: 단일 Terraform 코드베이스로 여러 클라우드 관리
- **Best Practices**: Drift Detection, Plan/Apply Workflow, Code Review

### GitOps & Configuration Management
- **ArgoCD**: App of Apps, Sync Policy, Health Check (애플리케이션 배포)
- **Kustomize**: Base/Overlay 패턴, 환경별 설정 관리
- **Helm**: CI/CD Pipeline 관리 (Tekton)
- **Declarative Management**: 애플리케이션 배포를 Git으로 추적

### CI/CD
- **Tekton**: Helm Chart 기반 Pipeline/Task/Trigger 구성
- **GitHub Webhook**: 자동 빌드 트리거 연동
- **Kaniko**: Docker-in-Docker 없이 컨테이너 이미지 빌드
- **Harbor**: Private Container Registry
- **Jenkins**: ECS Fargate Master-Slave

### Cloud Platforms
- **AWS**: VPC, EC2, EKS, RDS, S3, Glue, Athena, WorkSpaces, SSM, ECS Fargate
- **OCI**: VCN, OKE, Managed PostgreSQL, FastConnect, Block/Object Storage
- **Azure**: VNet, AKS, ExpressRoute, ACR
- **GCP**: App Engine, Cloud SQL, GKE

### Network & Security
- **Hybrid Network**: Site-to-Site VPN (Fortigate UTM), Cloud Interconnect (FastConnect, ExpressRoute)
- **Terraform 관리**: VPN Gateway, Route Table, Security Group, NACL
- **Security**: ISO 27001, ISO 27701, ISO 42001, ISMS-P 인증, Vault, Falco, Kyverno
- **VDI**: AWS WorkSpaces

### Kubernetes & Container
- **Production Operations**: 30 Nodes, 559 Pods, 30 Namespaces
- **Ingress**: Traefik LoadBalancer (YAML)
- **GitOps**: ArgoCD + Kustomize (애플리케이션 배포)
- **CI/CD**: Tekton (Helm Chart)
- **Autoscaling**: KEDA, VPA, HPA, Cluster Autoscaler, Descheduler, Goldilocks
- **Chaos Engineering**: Chaos Mesh
- **Registry**: Harbor
- **Authentication**: Authentik SSO

### AI/ML Infrastructure
- **GPU Monitoring**: DCGM Exporter (H100 8-GPU)
- **LLM Observability**: Langfuse (ISO 42001 대응)
- **Vector Database**: PostgreSQL (pgvector), ChromaDB
- **AI Governance**: AI 모델 버전 관리, 편향성 모니터링, 설명가능성

### Observability
- Prometheus, Grafana, Loki, DCGM Exporter, Langfuse, Kafka Exporter

### Data & Streaming
- Kafka, Kafka Connect, Schema Registry, KSQL, AWS Glue, Athena

### Blockchain
- Hyperledger Besu, QBFT, Truffle, Web3j, Blockscout

### Programming & Backend
- **Java, JSP (15년)**: Spring Boot, Tomcat, Servlet
- **Database**: MS SQL Server, MySQL, Oracle, MongoDB (성능 튜닝)
- **Mobile**: Android, iOS (Objective-C), WAP, 피처폰 VM
- **Scripting**: Bash, Python

---

**작성일**: 2026년 1월  
**연락처**: [refresh11@gmail.com]  
**Portfolio**: https://github.com/kimseungwook/sukim_pf
