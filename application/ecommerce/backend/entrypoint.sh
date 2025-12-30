#!/bin/sh
set -e

# MinIO endpoint from environment variable (supports docker-compose and K8s)
MINIO_ENDPOINT="${MINIO_ENDPOINT:-minio.minio.svc.cluster.local:9000}"

echo "Waiting for MinIO at ${MINIO_ENDPOINT}..."
until curl -s http://${MINIO_ENDPOINT}/minio/health/live; do
  echo "MinIO not ready, retrying in 2 seconds..."
  sleep 2
done

echo "MinIO is ready! Starting application..."
exec "/app/app"

