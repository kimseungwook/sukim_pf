#!/bin/bash
echo "=== Tekton 포드를 deploy 노드로 강제 이동 ==="

# 모든 Tekton deployment 수정
DEPLOYMENTS=$(kubectl get deployments -n tekton-pipelines -o name)

for deployment in $DEPLOYMENTS; do
    deployment_name=$(echo $deployment | cut -d'/' -f2)
    echo "수정 중: $deployment_name"
    
    # nodeSelector와 tolerations 추가
    kubectl patch deployment $deployment_name -n tekton-pipelines -p '{
      "spec": {
        "template": {
          "spec": {
            "nodeSelector": {
              "service": "tools"
            },
            "tolerations": [
              {
                "key": "service",
                "operator": "Equal",
                "value": "tools",
                "effect": "NoSchedule"
              }
            ]
          }
        }
      }
    }'
    
    # 포드 강제 재시작
    kubectl rollout restart deployment $deployment_name -n tekton-pipelines
done

# tekton-operator도 수정
echo "tekton-operator 수정 중..."
kubectl patch deployment tekton-operator -n tekton-operator -p '{
  "spec": {
    "template": {
      "spec": {
        "nodeSelector": {
          "service": "tools"
        },
        "tolerations": [
          {
            "key": "service",
            "operator": "Equal",
            "value": "tools",
            "effect": "NoSchedule"
          }
        ]
      }
    }
  }
}'

kubectl rollout restart deployment tekton-operator -n tekton-operator

echo "=== 포드 재시작 대기 중 ==="
sleep 30

echo "=== 새로운 포드 위치 확인 ==="
kubectl get pods -n tekton-pipelines -o wide
kubectl get pods -n tekton-operator -o wide