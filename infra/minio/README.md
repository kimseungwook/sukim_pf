# MinIO Object Storage

MinIO는 Amazon S3 API와 호환되는 고성능 오브젝트 스토리지입니다.

## 개요

- **Chart**: [CloudPirates MinIO](https://artifacthub.io/packages/helm/cloudpirates-minio/minio)
- **Version**: 0.6.0
- **Namespace**: `minio`
- **Storage Class**: `oci-bv` (OCI Block Volume)

## 주요 설정

### 인증 정보
- Root User는 `minio-secret` Secret에서 관리
- Secret 파일: `minio-secret.yaml` (gitignore에 추가 권장)

### 기본 버킷
다음 버킷이 자동으로 생성됩니다:
- `tekton-artifacts` - Tekton Pipeline 아티팩트 저장
- `harbor-storage` - Harbor 이미지 레지스트리 백엔드
- `backup` - 백업 데이터 저장

### 리소스
- CPU: 250m ~ 1000m
- Memory: 512Mi ~ 2Gi
- Storage: 50Gi (OCI Block Volume)

### 접속 정보
- **API Port**: 9000
- **Console Port**: 9090
- **Service Type**: ClusterIP

## 설치 방법

자세한 설치 절차는 `install.txt` 파일을 참고하세요.

```bash
# 1. Helm Repository 추가
helm repo add cloudpirates https://helm.cloudpirates.io
helm repo update

# 2. Namespace 및 Secret 생성
kubectl create namespace minio
kubectl apply -f minio/minio-secret.yaml

# 3. MinIO 설치
helm upgrade --install minio cloudpirates/minio \
  --version 0.6.0 \
  -f minio/values.yaml \
  -n minio
```

## 접속 방법

### Port Forward를 통한 로컬 접속

```bash
# Console 접속
kubectl port-forward -n minio svc/minio 9090:9090
```

브라우저에서 `http://localhost:9090` 접속

### Traefik IngressRoute 설정 (선택사항)

외부에서 접속하려면 IngressRoute를 설정하세요:
- API: `minio-api.sukim.site`
- Console: `minio-console.sukim.site`

## 사용 사례

### 1. Tekton Pipeline 아티팩트 저장
```yaml
# Tekton Task에서 MinIO 사용
spec:
  workspaces:
    - name: artifacts
      s3:
        endpoint: minio.minio.svc.cluster.local:9000
        bucket: tekton-artifacts
```

### 2. Harbor 백엔드 스토리지
Harbor의 `values.yaml`에서 MinIO를 백엔드로 설정:
```yaml
persistence:
  imageChartStorage:
    type: s3
    s3:
      region: ap-seoul-1
      bucket: harbor-storage
      endpoint: http://minio.minio.svc.cluster.local:9000
```

### 3. 백업 스토리지
애플리케이션 백업을 MinIO의 `backup` 버킷에 저장

## 보안 고려사항

1. **Secret 관리**
   - `minio-secret.yaml` 파일은 반드시 `.gitignore`에 추가
   - Production 환경에서는 강력한 암호 사용
   - 필요시 External Secrets Operator 또는 Vault 사용 고려

2. **Network Policy**
   - 필요한 Pod만 MinIO에 접근하도록 NetworkPolicy 설정 권장

3. **TLS**
   - Production 환경에서는 TLS 설정 권장
   - cert-manager와 통합하여 자동 인증서 관리

## 모니터링

MinIO는 Prometheus 메트릭을 지원합니다:
- Endpoint: `http://minio.minio.svc.cluster.local:9000/minio/v2/metrics/cluster`

Grafana 대시보드:
- [MinIO Dashboard](https://grafana.com/grafana/dashboards/13502)

## 트러블슈팅

자세한 트러블슈팅 방법은 `install.txt`의 트러블슈팅 섹션을 참고하세요.

### 일반적인 문제

1. **PVC Pending**
   - StorageClass `oci-bv`가 존재하는지 확인
   - `kubectl get sc`로 확인

2. **Pod CrashLoopBackOff**
   - Secret이 올바르게 설정되었는지 확인
   - `kubectl logs -n minio -l app=minio`로 로그 확인

3. **버킷 생성 실패**
   - Post-install Job 로그 확인: `kubectl logs -n minio job/minio-post-job`

## 참고 자료

- [MinIO Documentation](https://min.io/docs/minio/kubernetes/upstream/)
- [CloudPirates Helm Charts](https://github.com/CloudPirates-io/helm-charts)
- [MinIO S3 API Reference](https://docs.min.io/docs/minio-server-configuration-guide.html)
