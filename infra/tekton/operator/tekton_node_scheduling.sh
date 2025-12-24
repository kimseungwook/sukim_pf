#!/bin/bash
echo "=== TektonConfig profile을 all로 변경하여 Dashboard 설치 ==="

kubectl delete tektonconfig config --ignore-not-found=true
sleep 30

kubectl apply -f - <<EOF
apiVersion: operator.tekton.dev/v1alpha1
kind: TektonConfig
metadata:
  name: config
spec:
  profile: all
  targetNamespace: tekton-pipelines
  config:
    nodeSelector:
      goyo-svc: deploy
    tolerations:
    - key: "goyo-svc"
      operator: "Equal"
      value: "deploy"
      effect: "NoSchedule"
  dashboard:
    readonly: false
EOF

echo "Dashboard 설치 확인 중..."
sleep 60
kubectl get pods -n tekton-pipelines | grep dashboard
kubectl get svc -n tekton-pipelines tekton-dashboard