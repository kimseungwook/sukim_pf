#!/bin/bash
# CloudNativePG Cluster 재시작 스크립트

echo "=== CloudNativePG Cluster 설정 적용 및 재시작 ==="

# 1. 업데이트된 설정 적용
echo "1. Cluster 설정 적용..."
kubectl apply -f nocodb-pg-cluster.yaml

# 2. 잠시 대기
echo "2. 5초 대기 중..."
sleep 5

# 3. PodMonitor 확인
echo "3. PodMonitor 확인..."
kubectl get podmonitor -n cloudnative-pg

# 4. Cluster 상태 확인
echo "4. Cluster 상태 확인..."
kubectl get cluster -n cloudnative-pg nocodb-pg

# 5. Pod 상태 확인
echo "5. Pod 상태 확인..."
kubectl get pods -n cloudnative-pg

echo ""
echo "=== 완료! ==="
echo ""
echo "만약 PodMonitor가 생성되지 않았다면:"
echo "  kubectl delete pod -n cloudnative-pg nocodb-pg-1"
echo ""
echo "PodMonitor 상세 확인:"
echo "  kubectl describe podmonitor -n cloudnative-pg <podmonitor-name>"
echo ""
echo "Prometheus targets에서 확인:"
echo "  kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090:9090"
echo "  브라우저: http://localhost:9090/targets"
