# 🚀 최적화된 Backend System CI/CD

ReadWriteOnce PVC를 고려한 Mono Repo 친화적인 Tekton CI/CD 시스템입니다.

## 📋 주요 개선사항

### ✅ 해결된 문제점
- **PVC 동시 접근 문제**: 각 모듈별 독립적인 PVC로 병렬 빌드 지원
- **중복 코드 제거**: 통합 템플릿으로 유지보수성 향상
- **복잡한 조건부 로직 단순화**: EventListener 로직 최적화
- **Mono Repo 확장성**: 새 모듈 추가 용이성

### 🎯 최적화 포인트
- **모듈별 PVC 분리**: ReadWriteOnce 제약 해결
- **통합 파이프라인**: 단일 템플릿으로 모든 모듈 처리
- **동적 리소스 바인딩**: 실행 시 모듈별 적절한 PVC 선택
- **캐시 최적화**: 모듈별 Gradle 캐시로 빌드 성능 향상

## 🏗️ 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Webhook                          │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                 EventListener                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐│
│  │ Push Event  │ │  PR Event   │ │    Cleanup Event       ││
│  └─────────────┘ └─────────────┘ └─────────────────────────┘│
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│              Unified Pipeline                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐│
│  │ Git Clone   │ │ Build Image │ │  Update Manifest       ││
│  └─────────────┘ └─────────────┘ └─────────────────────────┘│
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│              Module-specific PVCs                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐│
│  │System PVC   │ │Portal PVC   │ │    Aify PVC            ││
│  │(Workspace + │ │(Workspace + │ │    (Workspace +        ││
│  │ Cache)      │ │ Cache)      │ │     Cache)             ││
│  └─────────────┘ └─────────────┘ └─────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

## 📦 설치 및 배포

### 1. Helm 차트 배포

```bash
# 네임스페이스 생성 (필요시)
kubectl create namespace tekton-pipelines

# Helm 차트 배포
helm install backend-system-optimized ./helm \
  --namespace tekton-pipelines \
  --values ./helm/values.yaml
```

### 2. 설정 확인

```bash
# PVC 생성 확인
kubectl get pvc -n tekton-pipelines | grep gointern-backend

# 파이프라인 생성 확인
kubectl get pipeline -n tekton-pipelines

# EventListener 상태 확인
kubectl get eventlistener -n tekton-pipelines
```

## 🔧 새 모듈 추가 방법

### 1. values.yaml에 새 모듈 추가

```yaml
modules:
  # 기존 모듈들...
  
  new-module:
    enabled: true
    gitBranch: "dev-new-module"
    moduleName: "goyoai-gointern-new"
    kustomize:
      branch: "dev"
      directory: "goyoai-new-module/overlays/dev"
      deploymentName: "dev-goyoai-new-module"
    dockerfileName: "dockerfile-new-dev"
    pvc:
      workspace: "gointern-backend-new"
      cache: "gointern-backend-new-cache"
```

### 2. Helm 업그레이드

```bash
helm upgrade backend-system-optimized ./helm \
  --namespace tekton-pipelines \
  --values ./helm/values.yaml
```

## 📊 모니터링 및 디버깅

### PVC 사용량 확인

```bash
# 각 모듈별 PVC 사용량 확인
kubectl exec -n tekton-pipelines \
  $(kubectl get pods -n tekton-pipelines -l app=tekton-pipelines-controller -o name | head -1) \
  -- df -h /workspace

# 캐시 효율성 확인
kubectl logs -n tekton-pipelines \
  -l tekton.dev/pipelineRun \
  --container=check-cache-status
```

### 빌드 성능 분석

```bash
# 빌드 시간 분석
kubectl get pipelineruns -n tekton-pipelines \
  -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[0].reason,DURATION:.status.completionTime

# 캐시 히트율 확인
kubectl logs -n tekton-pipelines \
  -l tekton.dev/pipelineRun \
  --container=post-build-analysis
```

## 🔄 롤백 방법

```bash
# 이전 버전으로 롤백
helm rollback backend-system-optimized 1 -n tekton-pipelines

# 특정 모듈만 비활성화
helm upgrade backend-system-optimized ./helm \
  --namespace tekton-pipelines \
  --set modules.problematic-module.enabled=false
```

## 🚨 트러블슈팅

### 일반적인 문제들

1. **PVC 마운트 실패**
   ```bash
   # PVC 상태 확인
   kubectl describe pvc -n tekton-pipelines
   
   # 스토리지 클래스 확인
   kubectl get storageclass
   ```

2. **빌드 실패**
   ```bash
   # 파이프라인 실행 로그 확인
   tkn pipelinerun logs -f -n tekton-pipelines
   
   # 특정 Task 로그 확인
   kubectl logs -n tekton-pipelines -l tekton.dev/task=build-container-image
   ```

3. **웹훅 이벤트 누락**
   ```bash
   # EventListener 로그 확인
   kubectl logs -n tekton-pipelines -l app.kubernetes.io/component=eventlistener
   ```

## 📚 참고 자료

- [Tekton Pipelines Documentation](https://tekton.dev/docs/pipelines/)
- [Tekton Triggers Documentation](https://tekton.dev/docs/triggers/)
- [Kaniko Documentation](https://github.com/GoogleContainerTools/kaniko)
- [Helm Charts Best Practices](https://helm.sh/docs/chart_best_practices/)

## 🤝 기여 방법

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 지원

문제가 발생하거나 질문이 있으시면:
- 📧 Email: devops@goyoai.com
- 💬 Slack: #devops-support
- 🐛 Issues: GitHub Issues 생성