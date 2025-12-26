# GoDaddy DNS-01 Challenge 빠른 시작 가이드

## 📌 개요
- **Webhook**: snowdrop/godaddy-webhook (최신 버전: v0.6.0)
- **Helm Repository**: https://snowdrop.github.io/godaddy-webhook
- **GitHub**: https://github.com/snowdrop/godaddy-webhook

## 🚀 빠른 설치 (5단계)

### 1️⃣ GoDaddy API 키 발급
```
https://developer.godaddy.com/keys
```
- **Environment**: Production 선택
- **API Key**와 **API Secret** 복사

### 2️⃣ godaddy-webhook 설치
```bash
# Helm repository 추가
helm repo add godaddy-webhook https://snowdrop.github.io/godaddy-webhook
helm repo update

# webhook 설치
helm install godaddy-webhook godaddy-webhook/godaddy-webhook \
  --namespace cert-manager \
  --set groupName=acme.sukim.com

# 확인
kubectl get pods -n cert-manager | grep godaddy
```

### 3️⃣ API Secret 생성
```bash
kubectl create secret generic godaddy-api-key \
  --from-literal=token=<API_KEY>:<API_SECRET> \
  --namespace cert-manager
```

**예시:**
```bash
kubectl create secret generic godaddy-api-key \
  --from-literal=token=abcd1234:xyz9876 \
  --namespace cert-manager
```

### 4️⃣ ClusterIssuer 배포
```bash
# Staging (테스트용)
kubectl apply -f infra/cert-manager/cert/clusterissuer-godaddy-staging.yaml

# Production (운영용) - 이메일 수정 필수!
kubectl apply -f infra/cert-manager/cert/clusterissuer-godaddy-prod.yaml
```

### 5️⃣ Certificate 발급
```bash
# 일반 도메인
kubectl apply -f infra/cert-manager/cert/certificate-example-godaddy.yaml

# 와일드카드 (*.example.com)
kubectl apply -f infra/cert-manager/cert/certificate-wildcard-godaddy.yaml
```

## ⚙️ 설정 파일 수정 필요 항목

### ClusterIssuer YAML 파일
- `email`: 실제 이메일 주소로 변경
- `groupName`: webhook 설치시 사용한 값과 동일하게 (현재: `acme.sukim.com`)

### Certificate YAML 파일
- `namespace`: 배포할 namespace
- `dnsNames`: GoDaddy에서 관리하는 실제 도메인으로 변경

## 📊 상태 확인 명령어

```bash
# ClusterIssuer 확인
kubectl get clusterissuer

# Certificate 확인
kubectl get certificate -A

# Challenge 확인 (문제 발생시)
kubectl get challenge -A

# Order 확인
kubectl get order -A

# Webhook 로그
kubectl logs -n cert-manager -l app.kubernetes.io/name=godaddy-webhook

# cert-manager 로그
kubectl logs -n cert-manager -l app.kubernetes.io/component=controller
```

## ⚠️ 중요 사항

1. **groupName 일치**: webhook 설치시 `--set groupName=acme.sukim.com`과 ClusterIssuer의 `groupName`이 **반드시 동일**해야 합니다

2. **DNS 전파 시간**: GoDaddy DNS 변경사항 전파에 최대 **10분** 소요

3. **Secret Namespace**: `godaddy-api-key` Secret은 **cert-manager namespace**에 있어야 합니다

4. **이메일 설정**: ClusterIssuer의 `email` 필드는 Let's Encrypt 알림을 받을 실제 이메일로 변경 필수

## 🎯 DNS-01의 장점
- ✅ **와일드카드 인증서** (`*.example.com`) 발급 가능
- ✅ 내부 서비스도 인증서 발급 가능 (외부 HTTP 접근 불필요)
- ✅ 포트 80(HTTP) 필요 없음

## 🔧 Traefik 연동 예시

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: my-app
  namespace: my-namespace
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`app.example.com`)
      kind: Rule
      services:
        - name: my-service
          port: 8080
  tls:
    secretName: wildcard-example-com-tls  # Certificate에서 생성된 Secret
```

## 📚 참고 문서
- [godaddy-webhook GitHub](https://github.com/snowdrop/godaddy-webhook)
- [GoDaddy Developer Portal](https://developer.godaddy.com/)
- [cert-manager DNS-01 Documentation](https://cert-manager.io/docs/configuration/acme/dns01/)
