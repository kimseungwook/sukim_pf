# 경력 기술서 (Career Description)

## 1. 프로젝트: AI Agent 서비스 플랫폼 구축 및 ISMS-P 인증 대응
*   **기간**: 2024.XX ~ 2024.XX (진행 중)
*   **역할**: DevOps Engineer / Infra Architect (Hybrid Cloud 및 GPU 모니터링 설계)
*   **기술 스택 (Tech Stack)**:
    *   **Cloud & Hybrid**: OCI (OKE), Azure (AKS), On-Premise GPU (H100), OCI-Azure Interconnect
    *   **AI Ops**: DCGM Exporter, Prometheus Operator, Langfuse, LangChain (Python)
    *   **Database**: OCI Managed PostgreSQL (pgvector), ChromaDB
    *   **Security & Compliance**: ISMS-P (심사 진행 중), Vault, Falco

### 주요 업무 및 성과 (Key Achievements)

#### 1) Multi-Cloud Strategy & FinOps (Azure vs OCI)
*   **Azure Infrastructure 0 to 1**: Azure Kubernetes Service(AKS), VNet, S2S VPN을 포함한 Azure 기반 서비스 환경을 구축하여 멀티 클라우드 운영 기반 마련.
*   **Cloud Interconnect**: OCI-Azure 간 **FastConnect**와 ExpressRoute를 연동하는 Low-Latency Interconnect를 구성하여 클라우드 간 고속 데이터 전송 환경 구현.
*   **Cost Optimization (FinOps)**: 운영 단계에서 Azure 대비 OCI의 비용 효율성(2배 이상의 비용 절감 효과)을 데이터로 증명하여, OCI 단일 클라우드로의 통합(Consolidation) 의사결정을 주도하고 마이그레이션을 수행.

#### 2) Hybrid AI 인프라 구축 및 GPU 관측성 확보
*   **Hybrid Cloud Architecture**: OCI(OKE)와 **On-Premise 고성능 GPU 서버(H100 8-way)**를 **Site-to-Site VPN**으로 연결하여 학습/추론 팜을 구성.
*   **GPU Monitoring Pipeline**: 외부 GPU 서버에 **DCGM Exporter**를 설치하고, OCI 상의 **Prometheus Operator**가 VPN을 통해 메트릭을 수집하도록(Federation/Scraping) 구성하여 고가 장비의 상태(온도, 전력, 사용률)를 중앙에서 통합 관제.

#### 3) LLM 서비스 최적화 및 운영 (GenAI Ops)
*   **Vector DB Modernization**: 초기 **ChromaDB**에서 **OCI Managed PostgreSQL (pgvector 확장)**로 마이그레이션하여, 관계형 데이터와 벡터 데이터의 정합성을 확보하고 관리 포인트를 일원화.
*   **LLM Observability**: **Langfuse**를 도입하여 **LangChain(Python)** 기반의 AI Agent 트랜잭션, 토큰 사용량, 지연 시간(Latency)을 추적하고 비용 및 성능 분석 체계 마련.

#### 4) ISMS-P 인증 및 보안 아키텍처
*   **ISMS-P 기술적 보호조치 이행**: 정보보호 및 개인정보보호 관리체계 예비 심사를 통과하고 본 심사를 주도적으로 리딩 (2025.01 인증 예정).
*   **DevSecOps**: Vault(Secret Zero), Falco(Runtime Security) 등 보안 솔루션을 내재화하여 금융/공공 수준의 컴플라이언스 요건 충족.


---

## 2. 프로젝트: 국내 최초 STO 부동산 조각 투자 플랫폼 인프라 구축 및 ISMS 인증
*   **기간**: 20XX.XX ~ 20XX.XX (기간 입력 필요)
*   **역할**: Cloud Infrastructure Engineer / DevOps (초기 구축 및 인증 주도)
*   **기술 스택 (Tech Stack)**:
    *   **Cloud**: AWS (VPC, EC2, RDS, SSM, WorkSpaces, IAM)
    *   **CI/CD**: Jenkins (Master-Slave on ECS Fargate), Elastic Beanstalk, SonarQube
    *   **Security**: ISMS 인증 대응, 망 분리

### 주요 업무 및 성과 (Key Achievements)

#### 1) ISMS 인증을 위한 금융권 수준의 보안 인프라 구축
*   **국내 최초 STO 분야 ISMS 인증 획득 기여**: 까다로운 심사 요건(망 분리, 접근 통제)을 클라우드 네이티브 기술로 충족.
*   **논리적 망 분리 (AWS WorkSpaces)**: 운영자 및 로그 관리자의 접근 환경을 VDI로 분리하여 내부망 접근 경로를 통제.
*   **Keyless 보안 접속 (SSM)**: SSH 키 관리의 위험을 없애기 위해 **Session Manager**를 도입, IAM 기반 인증과 명령어 로깅으로 감사(Audit) 요건 완벽 대응.

#### 2) AWS 인프라 0 to 1 구축 및 비용 최적화
*   **VPC 네트워크 설계**: Public/Private/DB Subnet 계층 분리 및 NACL/SG를 통한 최소 권한 트래픽 제어.
*   **RDS & Elastic Beanstalk**: 관리형 서비스(Managed Service)를 적극 활용하여 소규모 운영 인력으로도 고가용성 및 유지보수 편의성 확보.

#### 3) Serverless CI/CD 파이프라인
*   **Jenkins on ECS Fargate**: 상시 실행되는 Slave 서버 없이, 빌드 시에만 컨테이너를 생성하는 Master-Slave 구조를 구축하여 비용 절감 및 병렬 처리 효율 증대.
*   **DevSecOps 초석 마련**: SonarQube를 파이프라인에 통합하여 코드 품질과 보안 취약점을 지속적으로 관리.

---

## 3. 프로젝트: Hyperledger Besu 기반 스마트 컨트랙트 플랫폼 구축
*   **기간**: 20XX.XX ~ 20XX.XX (기간 입력 필요)
*   **역할**: DevOps Engineer (블록체인 인프라 및 네트워크 구축)
*   **기술 스택 (Tech Stack)**:
    *   **Blockchain**: Hyperledger Besu (Private Ethereum), Blockscout (EVM Explorer)
    *   **Cloud & Network**: AWS (VPC, VPN Site-to-Site), Hybrid Cloud
    *   **App**: Kotlin Spring Boot
    *   **Infra**: AWS (0 to 1 Setup)

### 주요 업무 및 성과 (Key Achievements)

#### 1) Enterprise Blockchain 인프라 0 to 1 구축 (Hybrid Compute Strategy)
*   **환경별 최적화된 아키텍처**:
    *   **Dev**: 빠른 프로토타이핑과 비용 효율성을 위해 **EC2** 기반으로 구성.
    *   **Prod**: 운영 안정성과 확장성을 고려하여 **AWS EKS (Kubernetes)** 기반으로 3개의 Validator 노드를 배포.
*   **Consensus Mechanism**: 엔터프라이즈 환경에 적합한 **QBFT (Quorum Byzantine Fault Tolerance)** 합의 알고리즘을 적용하여 퍼블릭 이더리움 대비 빠른 처리 속도와 파이널리티(Finality) 보장.
*   **Smart Contract 파이프라인**: **Truffle** 프레임워크를 도입하여 스마트 컨트랙트 컴파일, 테스트 및 배포 과정을 정형화하고, Kotlin Spring Boot 애플리케이션과의 Web3 연동 안정성 확보.
*   **운영 가시성 확보**: Blockscout를 구축하여 트랜잭션 흐름과 컨트랙트 상태를 실시간으로 시각화.

#### 2) 하이브리드 클라우드 네트워크 설계 (Hybrid Cloud Networking)
*   **AWS VPN Site-to-Site (S2S) 구성**: 사내망(On-Premise)과 AWS 클라우드 간의 보안 터널링(IPsec VPN)을 구축하여, 사내 개발 환경에서 클라우드 상의 블록체인 노드에 안전하게 접근 가능한 하이브리드 네트워크 구현.
*   **보안 중심의 VPC 설계**: 블록체인 노드와 Explorer 등 중요 자산을 Private Subnet에 배치하고, VPN을 통해서만 접근되도록 라우팅 및 보안 그룹(SG) 설계.

---

## 4. 프로젝트: IoT 기반 태양광 발전 데이터 수집 및 분석 플랫폼
*   **기간**: 20XX.XX ~ 20XX.XX (기간 입력 필요)
*   **역할**: Infrastructure Engineer / Data Engineer (AWS 0to1, 데이터 파이프라인 구축)
*   **기술 스택 (Tech Stack)**:
    *   **Cloud & Infra**: AWS EKS (Kubernetes), AWS Glue, Athena
    *   **Data Streaming**: Apache Kafka, Kafka Connect, KSQL, Schema Registry
    *   **DevOps**: ArgoCD, Tekton, Harbor, Traefik, Authentik

### 주요 업무 및 성과 (Key Achievements)

#### 1) 대용량 IoT 데이터 처리를 위한 Event-Driven 아키텍처 구현
*   **Kafka Ecosystem 구축**: 태양광 모듈에서 발생하는 실시간 발전 데이터를 수집하기 위해 Kafka, Kafka Connect, Schema Registry, KSQL을 Kubernetes 상에 구축하여 안정적인 데이터 스트리밍 환경 조성.
*   **Serverless Data Lake Pipeline (ETL)**:
    *   **Ingestion**: Kafka Connect를 통해 실시간 데이터를 S3로 적재(Sink).
    *   **Cataloging & Query**: **AWS Glue Crawler**를 이용해 S3에 적재된 데이터의 스키마를 자동 추출하여 Data Catalog를 생성하고, **Amazon Athena**를 통해 표준 SQL로 대용량 데이터를 즉시 분석할 수 있는 환경 제공. (Glue는 ETL 도구이자 메타데이터 카탈로그 역할을 수행합니다.)

#### 2) Kubernetes 기반의 확장 가능한 플랫폼 운영
*   **EKS & DevOps Stack**: 
    *   **ArgoCD & Tekton**: GitOps 기반의 배포 파이프라인과 CI 자동화.
    *   **Harbor**: Private Container Registry 구축.
    *   **Traefik**: Ingress Controller로 라우팅 관리.
    *   **Authentik**: 통합 인증(SSO) 솔루션을 도입하여 내부 서비스 접근 보안 강화.
*   **Monitoring**: Prometheus/Grafana를 통한 클러스터 및 카프카 상태 모니터링.

---

## 5. 프로젝트: 경영 데이터 분석 플랫폼 'Hyper Report' Web 버전 구축 및 이관
*   **기간**: 20XX.XX ~ 20XX.XX (약 1년 운영)
*   **역할**: DevOps Engineer (OCI 인프라 구축/운영 후 GCP 이관)
*   **기술 스택 (Tech Stack)**:
    *   **Phase 1 (OCI)**: OKE, Fortigate VPN (S2S), Chaos Mesh, KEDA, Goldilocks, VPA, Descheduler
    *   **Phase 2 (GCP)**: App Engine, Cloud SQL (MySQL), Makefile
    *   **DevOps**: ArgoCD, Tekton, Authentik, Cert-Manager

### 주요 업무 및 성과 (Key Achievements)

#### 1) Advanced Kubernetes Operations (OCI OKE)
*   **Resiliency & Autoscaling**: 단순한 운영을 넘어, **Chaos Mesh**를 도입하여 카오스 엔지니어링을 테스트하고, **KEDA**(Event-driven Autoscaling)와 **VPA**(Vertical Pod Autoscaler)를 결합하여 워크로드 특성에 맞는 정밀한 오토스케일링 환경을 구축.
*   **Resource Optimization**: **Goldilocks**로 적정 리소스 요청량(Request/Limit)을 추천받아 최적화하고, **Descheduler**로 노드 간 파드 밸런싱을 자동화하여 클러스터 안정성 확보.
*   **Hybrid Network**: 사내 레거시 네트워크(Fortinet UTM)와 OCI 간 **Site-to-Site VPN**을 직접 구축하여, 사내망과 클라우드 간 안전한 통신 터널링 구현.

#### 2) Cloud Migration & Handover (OCI -> GCP)
*   **Seamless Migration Strategy**: 계약 종료에 따라 고객사의 기존 클라우드 환경(GCP)으로 서비스를 이관하는 프로젝트 수행.
*   **GCP PaaS Architecture**: 관리 오버헤드를 최소화하기 위해 Kubernetes 대신 **Google App Engine**과 **Cloud SQL (Managed MySQL)** 구조로 재설계.
*   **Developer-Friendly Delivery**: 복잡한 배포 파이프라인 대신, 개발자가 단일 명령어로 배포할 수 있도록 **Makefile** 기반의 간소화된 배포 스크립트를 작성하여 안정적인 인수인계(Handover) 완료.
