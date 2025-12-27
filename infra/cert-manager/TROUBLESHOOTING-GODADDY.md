# GoDaddy DNS-01 Certificate Troubleshooting Guide

## 📋 목차
1. [일반적인 디버깅 명령어](#일반적인-디버깅-명령어)
2. [문제 1: API token Secret을 찾을 수 없음](#문제-1-api-token-secret을-찾을-수-없음)
3. [문제 2: groupName 불일치](#문제-2-groupname-불일치)
4. [문제 3: DNS 전파 시간 초과](#문제-3-dns-전파-시간-초과)
5. [문제 4: GoDaddy API 인증 실패](#문제-4-godaddy-api-인증-실패)
6. [문제 5: Let's Encrypt Rate Limit](#문제-5-lets-encrypt-rate-limit)

---

## 일반적인 디버깅 명령어

### 1️⃣ Certificate 상태 확인
```bash
# Certificate 목록 조회
kubectl get certificate -n <NAMESPACE>

# Certificate 상세 정보
kubectl describe certificate <CERT_NAME> -n <NAMESPACE>
```

**확인 포인트:**
- `READY`: `True`면 성공, `False`면 실패
- `Status.Conditions`: 현재 상태 메시지
- `Events`: 발급 과정의 이벤트 로그

### 2️⃣ CertificateRequest 확인
```bash
kubectl get certificaterequest -n <NAMESPACE>
kubectl describe certificaterequest <REQUEST_NAME> -n <NAMESPACE>
```

**확인 포인트:**
- `APPROVED`: `True`여야 함
- `DENIED`: `True`면 승인 거부됨
- `READY`: `True`면 인증서 발급 완료

### 3️⃣ Order 확인 (ACME)
```bash
kubectl get order -n <NAMESPACE>
kubectl describe order <ORDER_NAME> -n <NAMESPACE>
```

**상태:**
- `pending`: 처리 중
- `valid`: 성공
- `invalid`: 실패

### 4️⃣ Challenge 확인 (DNS-01)
```bash
kubectl get challenge -n <NAMESPACE>
kubectl describe challenge <CHALLENGE_NAME> -n <NAMESPACE>
```

**확인 포인트:**
- `STATE`: `valid`가 되어야 함
- `Reason`: 실패 원인
- `Presented`: DNS 레코드 생성 여부

### 5️⃣ 로그 확인
```bash
# cert-manager controller 로그
kubectl logs -n cert-manager -l app.kubernetes.io/component=controller --tail=100

# godaddy-webhook 로그
kubectl logs -n cert-manager -l app.kubernetes.io/name=godaddy-webhook --tail=100

# 특정 Challenge 관련 로그만 필터링
kubectl logs -n cert-manager -l app.kubernetes.io/component=controller | grep "godaddy-certificate"
```

### 6️⃣ ClusterIssuer 확인
```bash
kubectl get clusterissuer
kubectl describe clusterissuer letsencrypt-godaddy-prod
```

**확인 포인트:**
- `Status.Conditions.Ready`: `True`여야 함
- `Status.ACME.LastRegisteredEmail`: 올바른 이메일 확인

---

## 문제 1: API token Secret을 찾을 수 없음

### 🔴 증상
```
Error: API token field were not provided as no Kubernetes Secret exists !
Challenge STATE: pending
```

### 🔍 원인
**Secret이 Certificate와 다른 namespace에 있음**

예시:
- Secret 위치: `cert-manager` namespace
- Certificate 위치: `traefik` namespace

GoDaddy webhook은 Certificate가 있는 namespace에서 Secret을 찾으려고 시도합니다.

### ✅ 해결 방법

#### Option 1: Secret을 Certificate namespace에 복사 (권장)
```bash
# Secret 복사 (cert-manager → traefik)
kubectl get secret godaddy-api-key -n cert-manager -o yaml \
  | sed 's/namespace: cert-manager/namespace: traefik/' \
  | kubectl apply -f -

# 확인
kubectl get secret godaddy-api-key -n traefik
```

#### Option 2: Certificate를 cert-manager namespace로 이동
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: godaddy-certificate
  namespace: cert-manager  # Secret과 동일한 namespace
spec:
  secretName: godaddy-tls
  # ... 나머지 설정
```

#### Option 3: 모든 namespace에 Secret 배포
```bash
# 여러 namespace에서 인증서를 사용하는 경우
for ns in traefik default app1 app2; do
  kubectl get secret godaddy-api-key -n cert-manager -o yaml \
    | sed "s/namespace: cert-manager/namespace: $ns/" \
    | kubectl apply -f -
done
```

### ✅ 검증
```bash
# Challenge 상태 재확인 (1-2분 후)
kubectl get challenge -n traefik

# Challenge 로그 확인
kubectl logs -n cert-manager -l app.kubernetes.io/component=controller --tail=50 | grep "presenting DNS01"
```

성공 시 로그:
```
I1226 15:30:00 dns.go:90 "presenting DNS01 challenge for domain" domain="8ai.store"
I1226 15:30:05 dns.go:120 "DNS record created successfully"
```

---

## 문제 2: groupName 불일치

### 🔴 증상
```
Error: no matches for kind "Challenge" in webhook
Challenge가 생성되지 않음
```

### 🔍 원인
webhook 설치 시 사용한 `groupName`과 ClusterIssuer의 `groupName`이 다름

### ✅ 해결 방법

#### 1. webhook의 groupName 확인
```bash
helm get values godaddy-webhook -n cert-manager
```

출력 예시:
```yaml
groupName: acme.sukim.com
```

#### 2. ClusterIssuer 수정
```bash
kubectl edit clusterissuer letsencrypt-godaddy-prod
```

`groupName`을 webhook과 동일하게 변경:
```yaml
spec:
  acme:
    solvers:
    - dns01:
        webhook:
          groupName: acme.sukim.com  # webhook과 일치시킴
          solverName: godaddy
```

#### 3. 또는 webhook 재설치
```bash
# 기존 webhook 삭제
helm uninstall godaddy-webhook -n cert-manager

# 올바른 groupName으로 재설치
helm install godaddy-webhook godaddy-webhook/godaddy-webhook \
  --namespace cert-manager \
  --set groupName=acme.sukim.com
```

---

## 문제 3: DNS 전파 시간 초과

### 🔴 증상
```
Challenge STATE: pending (오랜 시간 지속)
Error: Timeout waiting for DNS record propagation
```

### 🔍 원인
- GoDaddy DNS 전파가 느림 (최대 10분)
- TTL 값이 너무 높음

### ✅ 해결 방법

#### 1. TTL 조정 (ClusterIssuer)
```yaml
spec:
  acme:
    solvers:
    - dns01:
        webhook:
          config:
            ttl: 600  # 10분 → 5분으로 변경 가능 (300)
```

#### 2. 수동 DNS 확인
```bash
# DNS TXT 레코드 확인
nslookup -type=TXT _acme-challenge.8ai.store 8.8.8.8

# 또는 dig 사용
dig TXT _acme-challenge.8ai.store @8.8.8.8
```

#### 3. 인내심 가지고 대기
- GoDaddy DNS는 일반적으로 **5-10분** 소요
- Challenge가 `pending` 상태면 대기 중
- 15분 이상 지나면 에러 확인 필요

---

## 문제 4: GoDaddy API 인증 실패

### 🔴 증상
```
Error: 401 Unauthorized
Error: Invalid API credentials
```

### 🔍 원인
- API Key 또는 Secret이 잘못됨
- Production/Test 환경 불일치

### ✅ 해결 방법

#### 1. Secret 내용 확인
```bash
# Secret 내용 디코딩
kubectl get secret godaddy-api-key -n cert-manager -o jsonpath='{.data.token}' | base64 -d
```

형식: `<API_KEY>:<API_SECRET>`

예시: `abcd1234efgh5678:XyZ9876AbCd5432`

#### 2. Secret 재생성
```bash
# 기존 Secret 삭제
kubectl delete secret godaddy-api-key -n cert-manager
kubectl delete secret godaddy-api-key -n traefik

# 새로운 Secret 생성
kubectl create secret generic godaddy-api-key \
  --from-literal=token=<YOUR_API_KEY>:<YOUR_API_SECRET> \
  --namespace cert-manager

kubectl create secret generic godaddy-api-key \
  --from-literal=token=<YOUR_API_KEY>:<YOUR_API_SECRET> \
  --namespace traefik
```

#### 3. Production 모드 확인
```yaml
spec:
  acme:
    solvers:
    - dns01:
        webhook:
          config:
            production: true  # Production API 사용
            # production: false → OTE (Test) API 사용
```

**주의:** GoDaddy API Key는 Production과 Test 환경이 구분됩니다!

---

## 문제 5: Let's Encrypt Rate Limit

### 🔴 증상
```
Error: too many certificates already issued for: 8ai.store
Error: Rate limit exceeded
```

### 🔍 원인
Let's Encrypt의 Rate Limit 초과:
- **50 certificates/week** per domain
- **5 duplicates/week** (동일한 도메인 조합)

### ✅ 해결 방법

#### 1. Staging 환경 사용 (테스트용)
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-godaddy-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory  # Staging
    # ... 나머지 동일
```

Certificate에서 Staging Issuer 사용:
```yaml
spec:
  issuerRef:
    name: letsencrypt-godaddy-staging  # Staging으로 변경
    kind: ClusterIssuer
```

**주의:** Staging 인증서는 브라우저에서 신뢰되지 않음 (테스트 전용)

#### 2. Rate Limit 확인
https://crt.sh 에서 도메인 검색하여 발급 이력 확인

#### 3. 대기
- Rate Limit은 **주간 단위**로 리셋됨
- 급한 경우 다른 서브도메인 사용 고려

---

## 🔧 완전한 디버깅 체크리스트

### Step 1: 기본 설정 확인
```bash
# 1. godaddy-webhook Pod 실행 중?
kubectl get pods -n cert-manager | grep godaddy

# 2. ClusterIssuer Ready?
kubectl get clusterissuer letsencrypt-godaddy-prod

# 3. Secret 존재?
kubectl get secret godaddy-api-key -n cert-manager
kubectl get secret godaddy-api-key -n <CERT_NAMESPACE>
```

### Step 2: Certificate 발급 흐름 추적
```bash
# 1. Certificate 상태
kubectl get certificate -n <NAMESPACE>

# 2. CertificateRequest 생성됨?
kubectl get certificaterequest -n <NAMESPACE>

# 3. Order 생성됨?
kubectl get order -n <NAMESPACE>

# 4. Challenge 생성됨?
kubectl get challenge -n <NAMESPACE>
```

### Step 3: Challenge 상세 검사
```bash
# Challenge 이벤트 확인
kubectl describe challenge <CHALLENGE_NAME> -n <NAMESPACE>

# 주요 확인 사항:
# - State: pending/valid/invalid
# - Presented: true/false
# - Reason: 에러 메시지
```

### Step 4: 로그 분석
```bash
# cert-manager logs에서 에러 찾기
kubectl logs -n cert-manager -l app.kubernetes.io/component=controller | grep -i error

# godaddy-webhook logs 확인
kubectl logs -n cert-manager -l app.kubernetes.io/name=godaddy-webhook --tail=100
```

### Step 5: DNS 검증
```bash
# TXT 레코드가 생성되었는지 확인
dig TXT _acme-challenge.<YOUR_DOMAIN> @8.8.8.8

# 또는 nslookup
nslookup -type=TXT _acme-challenge.<YOUR_DOMAIN> 8.8.8.8
```

---

## 📊 성공 시 예상 흐름

### 1. Certificate 생성
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: godaddy-certificate
  namespace: traefik
spec:
  secretName: godaddy-tls
  issuerRef:
    name: letsencrypt-godaddy-prod
    kind: ClusterIssuer
  dnsNames:
  - "*.8ai.store"
```

### 2. 자동 생성되는 리소스
```
Certificate (생성)
  ↓
CertificateRequest (자동 생성)
  ↓
Order (자동 생성)
  ↓
Challenge (자동 생성)
  ↓
DNS TXT 레코드 생성
  ↓
Let's Encrypt 검증
  ↓
인증서 발급
  ↓
Secret 생성 (type: kubernetes.io/tls)
```

### 3. 성공 확인
```bash
# Certificate READY=True
kubectl get certificate -n traefik
NAME                  READY   SECRET        AGE
godaddy-certificate   True    godaddy-tls   5m

# TLS Secret 생성됨
kubectl get secret godaddy-tls -n traefik
NAME          TYPE                DATA   AGE
godaddy-tls   kubernetes.io/tls   3      5m

# Secret 내용 확인
kubectl get secret godaddy-tls -n traefik -o yaml
```

---

## 🆘 긴급 상황 대응

### Certificate가 계속 실패할 때
```bash
# 1. 모든 리소스 삭제 후 재시작
kubectl delete certificate godaddy-certificate -n traefik
kubectl delete certificaterequest --all -n traefik
kubectl delete order --all -n traefik
kubectl delete challenge --all -n traefik

# 2. Secret도 삭제 (새로 발급)
kubectl delete secret godaddy-certificate-* -n traefik

# 3. Certificate 재생성
kubectl apply -f godaddy_wild_cert.yaml
```

### webhook이 응답하지 않을 때
```bash
# webhook Pod 재시작
kubectl delete pod -n cert-manager -l app.kubernetes.io/name=godaddy-webhook

# webhook 재설치
helm uninstall godaddy-webhook -n cert-manager
helm install godaddy-webhook godaddy-webhook/godaddy-webhook \
  --namespace cert-manager \
  --set groupName=acme.sukim.com
```

### cert-manager 자체 문제
```bash
# cert-manager Pod 재시작
kubectl rollout restart deployment cert-manager -n cert-manager
kubectl rollout restart deployment cert-manager-webhook -n cert-manager
kubectl rollout restart deployment cert-manager-cainjector -n cert-manager
```

---

## 📚 추가 참고 자료

- [cert-manager DNS-01 Documentation](https://cert-manager.io/docs/configuration/acme/dns01/)
- [GoDaddy API Documentation](https://developer.godaddy.com/doc)
- [godaddy-webhook GitHub](https://github.com/snowdrop/godaddy-webhook)
- [Let's Encrypt Rate Limits](https://letsencrypt.org/docs/rate-limits/)
- [crt.sh - Certificate Search](https://crt.sh)

---

## 💡 Best Practices

1. **항상 Staging으로 테스트**: 처음에는 `letsencrypt-godaddy-staging` 사용
2. **Secret 관리**: 필요한 모든 namespace에 `godaddy-api-key` 복사
3. **groupName 일관성**: webhook과 ClusterIssuer에서 동일하게 유지
4. **로그 모니터링**: 발급 과정 중 로그 실시간 확인
5. **DNS 확인**: Challenge 생성 후 `dig` 명령어로 TXT 레코드 검증
6. **인내심**: GoDaddy DNS 전파는 5-10분 소요

---

> **작성일**: 2025-12-27  
> **버전**: 1.0  
> **관련 파일**:
> - `godaddy-dns01-setup.txt` - 설치 가이드
> - `QUICKSTART-GODADDY.md` - 빠른 시작
> - `godaddy_clusterIssue.yaml` - ClusterIssuer 설정
> - `godaddy_wild_cert.yaml` - Certificate 예제
