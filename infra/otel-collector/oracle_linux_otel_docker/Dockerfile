# Oracle Linux 8 기반 OpenJDK 17 + OpenTelemetry Java Agent

FROM openjdk:26-ea-17-jdk-oraclelinux8
LABEL maintainer="devops@goyoai.com"
LABEL description="Oracle Linux 8 with OpenJDK 17 and OpenTelemetry Java Agent"
LABEL otel.version="2.19.0"
LABEL base.image="openjdk:17-jdk-oraclelinux8"

# 타임존 설정
# ENV TZ=Asia/Seoul
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
#     echo $TZ > /etc/timezone

# OTel Agent 다운로드 및 검증
RUN curl -L -o /opt/opentelemetry-javaagent.jar \
    https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.21.0/opentelemetry-javaagent.jar && \
    chmod 644 /opt/opentelemetry-javaagent.jar && \
    echo "Downloaded OpenTelemetry Java Agent:" && \
    ls -lh /opt/opentelemetry-javaagent.jar && \
    sha256sum /opt/opentelemetry-javaagent.jar

# 환경 변수로 agent 경로 제공
ENV OTEL_JAVAAGENT_PATH=/opt/opentelemetry-javaagent.jar

# 작업 디렉토리 설정
WORKDIR /app