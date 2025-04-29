{{/*
Renders rollout template.
Must be called from chart root context.
Usage:
{{ include "cf-common-0.24.0.controller.rollout" . }}
*/}}
{{- define "cf-common-0.24.0.controller.rollout" -}}

{{- $fullName:= include "cf-common-0.24.0.names.fullname" . }}

{{- $controllerValues := deepCopy .Values.controller -}}
{{- $rolloutValues := dict -}}
{{- if .Values.controller.rollout -}}
    {{- $rolloutValues = deepCopy .Values.controller.rollout -}}
{{- end -}}
{{- $mergedControllerValues := mergeOverwrite $controllerValues $rolloutValues -}}
{{- $_ := set .Values "controller" (deepCopy $mergedControllerValues) -}}

{{- $strategy := default "Canary" .Values.controller.strategy -}}

{{- if and (ne $strategy "Canary") (ne $strategy "BlueGreen") -}}
  {{- fail (printf "ERROR: %s is invalid Rollout strategy!" $strategy) -}}
{{- end -}}

{{- $rolloutName := include "cf-common-0.24.0.names.fullname" . -}}
{{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
  {{- $rolloutName = printf "%v-%v" $rolloutName .Values.controller.nameOverride -}}
{{- end -}}

---
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: {{ $rolloutName }}
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
    {{- with .Values.controller.rollout }}
  analysis: {{ .analysis | toYaml | nindent 4 }}
    {{- end }}
  strategy:
    {{- if eq $strategy "Canary" }}
      {{- if not .Values.controller.rollout }}
        {{- fail "ERROR: controller.rollout.canary.steps is required!" }}
      {{- end }}
      {{- with .Values.controller.rollout }}
    canary:
      maxUnavailable: {{ .canary.maxUnavailable }}
      maxSurge: {{ .canary.maxSurge }}
      stableMetadata: {{ .canary.stableMetadata| toYaml | nindent 8 }}
      canaryMetadata: {{ .canary.canaryMetadata| toYaml | nindent 8 }}
      steps: {{ .canary.steps | toYaml | nindent 6 }}
      {{- if .analysisTemplate }}
        {{- if .analysisTemplate.enabled }}
      - analysis:
          templates:
            - templateName: error-rate-{{ $fullName }}
        {{- end }}
      {{- end }}
      {{- end }}
    {{- else if eq $strategy "BlueGreen" }}
      {{/*TO-DO*/}}
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
