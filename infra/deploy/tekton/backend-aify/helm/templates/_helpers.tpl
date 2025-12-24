{{/*
templates/_helpers.tpl - 최적화된 공통 템플릿 함수 정의 (aify 제거)
=================================================================
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "aify-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "aify-backend.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aify-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels - 모듈화된 구조 지원
*/}}
{{- define "aify-backend.labels" -}}
helm.sh/chart: {{ include "aify-backend.chart" . }}
{{ include "aify-backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aify-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aify-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "aify-backend.annotations" -}}
{{- with .Values.commonAnnotations }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Generate PVC name for module workspace
*/}}
{{- define "aify-backend.workspacePvcName" -}}
{{- printf "%s-workspace-%s" .Values.global.project_name . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate cache PVC name for module
*/}}
{{- define "aify-backend.cachePvcName" -}}
{{- printf "%s-cache-%s" .Values.global.project_name . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate task name for module
*/}}
{{- define "aify-backend.taskName" -}}
{{- printf "%s-%s-image-build" .Values.global.project_name . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate pipeline name for module
*/}}
{{- define "aify-backend.pipelineName" -}}
{{- printf "goyoai-gointern-%s" . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common environment variables for Gradle builds
*/}}
{{- define "aify-backend.gradleEnv" -}}
- name: GRADLE_USER_HOME
  value: {{ .Values.build.gradle.userHome | quote }}
- name: GRADLE_OPTS
  value: {{ .Values.build.gradle.opts | quote }}
{{- end }}

{{/*
Common Kaniko arguments
*/}}
{{- define "aify-backend.kanikoArgs" -}}
{{- range .Values.build.kaniko.args }}
- {{ . | quote }}
{{- end }}
{{- end }}

{{/*
Generate image tag with timestamp and git sha
*/}}
{{- define "aify-backend.imageTag" -}}
{{- printf "%s-%s" . (required "git-short-sha is required" $.gitShortSha) }}
{{- end }}

{{/*
Node selector helper
*/}}
{{- define "aify-backend.nodeSelector" -}}
{{- if .Values.pipeline.nodeSelector }}
{{- toYaml .Values.pipeline.nodeSelector | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Tolerations helper
*/}}
{{- define "aify-backend.tolerations" -}}
{{- if .Values.pipeline.tolerations }}
{{- toYaml .Values.pipeline.tolerations | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Security context helper
*/}}
{{- define "aify-backend.securityContext" -}}
{{- toYaml .Values.security.securityContext | nindent 0 }}
{{- end }}

{{/*
Pod security context helper
*/}}
{{- define "aify-backend.podSecurityContext" -}}
{{- toYaml .Values.security.podSecurityContext | nindent 0 }}
{{- end }}

{{/*
Docker config volume
*/}}
{{- define "aify-backend.dockerConfigVolume" -}}
- name: docker-config
  secret:
    secretName: {{ .Values.global.registry.secret }}
    items:
      - key: .dockerconfigjson
        path: config.json
{{- end }}

{{/*
Validate enabled modules
*/}}
{{- define "aify-backend.validateModules" -}}
{{- $enabledCount := 0 }}
{{- range $moduleName, $moduleConfig := .Values.modules }}
{{- if $moduleConfig.enabled }}
{{- $enabledCount = add $enabledCount 1 }}
{{- end }}
{{- end }}
{{- if eq $enabledCount 0 }}
{{- fail "최소 하나의 모듈은 enabled: true로 설정되어야 합니다" }}
{{- end }}
{{- end }}

{{/*
Generate branch list for CEL filter
*/}}
{{- define "aify-backend.gitBranches" -}}
{{- $branches := list }}
{{- range $moduleName, $moduleConfig := .Values.modules }}
{{- if $moduleConfig.enabled }}
{{- $branches = append $branches $moduleConfig.git.branch }}
{{- end }}
{{- end }}
{{- $branches | join "', '" | printf "'%s'" }}
{{- end }}

{{/*
Generate module mapping for CEL expressions
*/}}
{{- define "aify-backend.moduleMapping" -}}
{{- range $moduleName, $moduleConfig := .Values.modules }}
{{- if $moduleConfig.enabled }}
body.ref.split('/')[2] == '{{ $moduleConfig.git.branch }}' ? '{{ $moduleConfig.build.moduleName }}' :
{{- end }}
{{- end }}
'unknown'
{{- end }}

{{/*
Generate PVC mapping for CEL expressions
*/}}
{{- define "aify-backend.pvcMapping" -}}
{{- range $moduleName, $moduleConfig := .Values.modules }}
{{- if $moduleConfig.enabled }}
body.ref.split('/')[2] == '{{ $moduleConfig.git.branch }}' ? '{{ $moduleConfig.pvc.workspace }}' :
{{- end }}
{{- end }}
'unknown'
{{- end }}

{{/*
Generate Dockerfile mapping for CEL expressions
*/}}
{{- define "aify-backend.dockerfileMapping" -}}
{{- range $moduleName, $moduleConfig := .Values.modules }}
{{- if $moduleConfig.enabled }}
body.ref.split('/')[2] == '{{ $moduleConfig.git.branch }}' ? '{{ $moduleConfig.build.dockerfileName }}' :
{{- end }}
{{- end }}
'dockerfile-system-dev'
{{- end }}

{{/*
Common resource limits and requests
*/}}
{{- define "aify-backend.resources" -}}
requests:
  memory: "512Mi"
  cpu: "250m"
limits:
  memory: "2Gi"
  cpu: "1"
{{- end }}

{{/*
Generate workspace volume claim template
*/}}
{{- define "aify-backend.workspaceVolumeClaimTemplate" -}}
- metadata:
    name: workspace
  spec:
    accessModes: [ "ReadWriteOnce" ]
    storageClassName: {{ .Values.global.storage.className }}
    resources:
      requests:
        storage: 5Gi
{{- end }}

{{/*
Generate cache volume claim template
*/}}
{{- define "aify-backend.cacheVolumeClaimTemplate" -}}
- metadata:
    name: cache
  spec:
    accessModes: [ "ReadWriteOnce" ]
    storageClassName: {{ .Values.global.storage.className }}
    resources:
      requests:
        storage: {{ .Values.global.storage.size }}
{{- end }}

{{/*
=================================================================
유틸리티 함수들 - 20년차 DevOps 모범 사례 적용
=================================================================

1. 모듈화된 구조 지원
2. 동적 값 생성 및 매핑
3. 보안 컨텍스트 표준화
4. 리소스 최적화
5. 확장 가능한 템플릿 구조

사용 예시:
- {{ include "aify-backend.labels" . }}
- {{ include "aify-backend.moduleMapping" . }}
- {{ include "aify-backend.validateModules" . }}

=================================================================
*/}}
