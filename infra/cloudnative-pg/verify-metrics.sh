#!/bin/bash
# CloudNativePG 메트릭 수집 확인 스크립트

echo "=========================================="
echo "CloudNativePG 메트릭 수집 검증"
echo "=========================================="
echo ""

# 1. PodMonitor 확인
echo "1️⃣  PodMonitor 확인"
echo "-------------------------------------------"
kubectl get podmonitor -n cloudnative-pg
echo ""

# 2. PostgreSQL Cluster 상태 확인
echo "2️⃣  PostgreSQL Cluster 상태"
echo "-------------------------------------------"
kubectl get cluster -n cloudnative-pg
echo ""

# 3. PostgreSQL Pod 확인
echo "3️⃣  PostgreSQL Pod 상태"
echo "-------------------------------------------"
kubectl get pods -n cloudnative-pg
echo ""

# 4. Pod의 메트릭 엔드포인트 확인
echo "4️⃣  메트릭 엔드포인트 직접 확인"
echo "-------------------------------------------"
POD_NAME=$(kubectl get pods -n cloudnative-pg -l cnpg.io/cluster=nocodb-pg -o jsonpath='{.items[0].metadata.name}')
echo "Pod 이름: $POD_NAME"
echo ""
echo "메트릭 샘플 (처음 50줄):"
kubectl exec -n cloudnative-pg $POD_NAME -- curl -s http://localhost:9187/metrics | head -n 50
echo ""
echo "cnpg_pg_replication 메트릭 검색:"
kubectl exec -n cloudnative-pg $POD_NAME -- curl -s http://localhost:9187/metrics | grep cnpg_pg_replication
echo ""

# 5. PodMonitor 상세 정보
echo "5️⃣  PodMonitor 상세 설정"
echo "-------------------------------------------"
PODMONITOR_NAME=$(kubectl get podmonitor -n cloudnative-pg -o jsonpath='{.items[0].metadata.name}')
if [ -n "$PODMONITOR_NAME" ]; then
    echo "PodMonitor 이름: $PODMONITOR_NAME"
    kubectl get podmonitor -n cloudnative-pg $PODMONITOR_NAME -o yaml | grep -A 20 "spec:"
else
    echo "⚠️  PodMonitor를 찾을 수 없습니다!"
fi
echo ""

# 6. Prometheus에서 메트릭 확인 (선택사항)
echo "6️⃣  Prometheus 메트릭 쿼리"
echo "-------------------------------------------"
echo "Prometheus UI에서 확인하려면:"
echo "  kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090:9090"
echo "  브라우저: http://localhost:9090"
echo ""
echo "쿼리 예시:"
echo "  cnpg_pg_replication_streaming_replicas"
echo "  cnpg_backends_waiting_total"
echo "  cnpg_pg_stat_database_xact_commit{datname=\"nocodb\"}"
echo ""

# 7. ConfigMap 확인 (custom queries)
echo "7️⃣  Monitoring ConfigMap 확인"
echo "-------------------------------------------"
kubectl get configmap -n cloudnative-pg cnpg-default-monitoring -o yaml | grep -A 5 "queries:"
echo ""

echo "=========================================="
echo "✅ 검증 완료!"
echo "=========================================="
echo ""
echo "다음 단계:"
echo "  1. 위에서 메트릭이 보이면 → Prometheus UI에서 확인"
echo "  2. 메트릭이 안 보이면 → Pod 재시작 필요"
echo "     kubectl delete pod -n cloudnative-pg $POD_NAME"
echo ""
