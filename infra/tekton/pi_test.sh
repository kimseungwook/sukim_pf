#!/bin/bash

echo "=== 1. Secret 도메인 확인 ==="
kubectl get secret harbor-internal-registry-secret -n tekton-pipelines -o jsonpath='{.data.\.dockerconfigjson}' | base64 -d | jq

echo -e "\n=== 2. Task 이미지 목록 ==="
kubectl get task gointern-manifest-jib -n tekton-pipelines -o yaml | grep "image:" | sort -u

echo -e "\n=== 3. 노드에서 이미지 pull 테스트 ==="
for NODE in $(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'); do
  echo "Testing node: $NODE"
  ssh $NODE "sudo crictl pull gdhb.go-intern.io/common/alpine:3.20.3 2>&1 | head -5"
done

echo -e "\n=== 4. Pod hostAliases 확인 ==="
POD=$(kubectl get pods -n tekton-pipelines --sort-by=.metadata.creationTimestamp | grep manifest-jib | tail -1 | awk '{print $1}')
kubectl get pod $POD -n tekton-pipelines -o yaml | grep -A10 hostAliases