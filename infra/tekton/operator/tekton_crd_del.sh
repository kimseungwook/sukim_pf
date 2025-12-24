#!/bin/bash
echo "=== Tekton 리소스 완전 강제 정리 ==="

# tekton-pipelines namespace의 모든 Tekton 리소스 강제 삭제
TEKTON_RESOURCES=(
    "pipelineruns"
    "taskruns" 
    "customruns"
    "runs"
    "pipelines"
    "tasks"
    "clustertasks"
    "conditions"
    "pipelineresources"
    "stepactions"
    "resolutionrequests"
    "verificationpolicies"
)

for resource in "${TEKTON_RESOURCES[@]}"; do
    echo "삭제 중: $resource"
    # 모든 인스턴스의 finalizer 제거
    kubectl get $resource -n tekton-pipelines -o name 2>/dev/null | while read item; do
        kubectl patch $item -n tekton-pipelines -p '{"metadata":{"finalizers":[]}}' --type=merge 2>/dev/null || true
        kubectl delete $item -n tekton-pipelines --force --grace-period=0 2>/dev/null || true
    done
done

# 나머지 모든 리소스 강제 삭제
kubectl delete all --all -n tekton-pipelines --force --grace-period=0 --timeout=30s || true
kubectl delete configmap,secret,serviceaccount,role,rolebinding --all -n tekton-pipelines --force --grace-period=0 || true

# namespace finalizer 제거
kubectl patch namespace tekton-pipelines -p '{"spec":{"finalizers":[]}}' --type=merge || true
kubectl delete namespace tekton-pipelines --force --grace-period=0 || true