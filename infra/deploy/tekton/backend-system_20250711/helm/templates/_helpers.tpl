{{/*
templates/_helpers.tpl - 공통 템플릿 함수 정의
=================================================================
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "backend-system.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "backend-system.fullname" -}}
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
{{- define "backend-system.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "backend-system.labels" -}}
helm.sh/chart: {{ include "backend-system.chart" . }}
{{ include "backend-system.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels }}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "backend-system.selectorLabels" -}}
app.kubernetes.io/name: {{ include "backend-system.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Node selector template
*/}}
{{- define "backend-system.nodeSelector" -}}
{{- if .Values.scheduling }}
{{- if .Values.scheduling.nodeSelector }}
{{ .Values.scheduling.nodeSelector.key }}: {{ .Values.scheduling.nodeSelector.value }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Tolerations template
*/}}
{{- define "backend-system.tolerations" -}}
{{- if .Values.scheduling }}
{{- if .Values.scheduling.tolerations }}
- key: {{ .Values.scheduling.tolerations.key }}
  operator: {{ .Values.scheduling.tolerations.operator }}
  value: {{ .Values.scheduling.tolerations.value }}
  effect: {{ .Values.scheduling.tolerations.effect }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "backend-system.annotations" -}}
{{- if .Values.commonAnnotations }}
{{ toYaml .Values.commonAnnotations }}
{{- end }}
{{- end }}

{{/*
Generate PVC name for module
*/}}
{{- define "backend-system.pvcName" -}}
{{- printf "%s-%s" .Values.project.name . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate cache PVC name for module
*/}}
{{- define "backend-system.cachePvcName" -}}
{{- printf "%s-cache-%s" .Values.project.name . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate task name for module
*/}}
{{- define "backend-system.taskName" -}}
{{- printf "%s-%s-build" .Values.project.name . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate pipeline name for module
*/}}
{{- define "backend-system.pipelineName" -}}
{{- printf "%s-%s" .Values.project.name . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common environment variables for builds
*/}}
{{- define "backend-system.buildEnv" -}}
- name: GRADLE_USER_HOME
  value: "/workspace/gradle-home"
- name: GRADLE_OPTS
  value: "{{ .Values.build.gradle.opts | default "-Dorg.gradle.daemon=false -Dorg.gradle.parallel=true -Dorg.gradle.workers.max=2 -Dorg.gradle.caching=true -Dorg.gradle.vfs.watch=false -Dkotlin.compiler.execution.strategy=in-process" }}"
{{- end }}

{{/*
Common volume mounts for builds
*/}}
{{- define "backend-system.buildVolumeMounts" -}}
- name: docker-config
  mountPath: /kaniko/.docker
- name: gradle-cache-dir
  mountPath: /workspace/gradle-home
- name: kaniko-cache
  mountPath: /cache
{{- end }}

{{/*
Common volumes for builds
*/}}
{{- define "backend-system.buildVolumes" -}}
- name: docker-config
  secret:
    secretName: {{ .Values.registry.secretName | default .Values.container_registry_secretName }}
    items:
      - key: .dockerconfigjson
        path: config.json
- name: kaniko-cache
  emptyDir: 
    sizeLimit: 10Gi
{{- end }}
