{{/*
Renders deployment template
Must be called from chart root context.
Usage:
{{ include "cf-common-0.24.0.controller.deployment" . }}
*/}}

{{- define "cf-common-0.24.0.controller.deployment" -}}

{{- $controllerValues := deepCopy .Values.controller -}}
{{- $deploymentValues := dict -}}
{{- if .Values.controller.deployment -}}
    {{- $deploymentValues = deepCopy .Values.controller.deployment -}}
{{- end -}}
{{- $mergedControllerValues := mergeOverwrite $controllerValues $deploymentValues -}}
{{- $_ := set .Values "controller" (deepCopy $mergedControllerValues) -}}

{{- $strategy := default "RollingUpdate" .Values.controller.strategy -}}

{{- if and (ne $strategy "RollingUpdate") (ne $strategy "Recreate") -}}
  {{- fail (printf "ERROR: %s is invalid Deployment strategy!" $strategy) -}}
{{- end -}}

{{- $deploymentName := include "cf-common-0.24.0.names.fullname" . -}}
{{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
  {{- $deploymentName = printf "%v-%v" $deploymentName .Values.controller.nameOverride -}}
{{- end -}}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $deploymentName }}
  labels: {{ include "cf-common-0.24.0.labels.standard" . | nindent 4 }}
  {{- if .Values.controller.labels }}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.controller.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.controller.annotations }}
  annotations:
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.controller.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: {{ .Values.controller.revisionHistoryLimit | int | default 5 }}
  {{- if and (ne .Values.hpa.enabled true) (ne .Values.keda.enabled true) }}
  replicas: {{ coalesce .Values.controller.replicas .Values.replicaCount | int | default 1 }}
  {{- end }}
  selector:
    matchLabels: {{ include "cf-common-0.24.0.labels.matchLabels" . | nindent 6 }}
  strategy:
    type: {{ $strategy }}
    {{- with .Values.controller.rollingUpdate }}
      {{- if eq $strategy "RollingUpdate" }}
    rollingUpdate:
        {{- with .maxUnavailable }}
      maxUnavailable: {{ . }}
        {{- end }}
        {{- with .maxSurge }}
      maxSurge: {{ . }}
        {{- end }}
      {{- end }}
    {{- end }}
  template:
    metadata:
      labels: {{ include "cf-common-0.24.0.labels.matchLabels" . | nindent 8 }}
      {{- if .Values.podLabels }}
      {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.podAnnotations }}
      annotations:
      {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.podAnnotations "context" $) | nindent 8 }}
      {{- end }}
    spec: {{- include "cf-common-0.24.0.controller.pod" . | trim | nindent 6 -}}
{{- end -}}
