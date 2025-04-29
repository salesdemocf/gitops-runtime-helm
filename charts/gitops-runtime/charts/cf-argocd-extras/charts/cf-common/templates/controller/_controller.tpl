{{/*
Renders contoller object.
Must be called from chart root context.
Usage:
{{- include "cf-common-0.24.0.controller" . -}}
*/}}

{{- define "cf-common-0.24.0.controller" -}}

{{- if .Values.controller.enabled -}}

  {{- $defaultControllerValues := deepCopy .Values.controller -}}
  {{- $globalControllerValues := dict -}}
  {{- if .Values.global -}}
    {{- if .Values.global.controller -}}
      {{- $globalControllerValues = deepCopy .Values.global.controller -}}
    {{- end -}}
  {{- end -}}
  {{- $mergedControllerValues := mergeOverwrite $globalControllerValues $defaultControllerValues -}}
  {{- $_ := set .Values "controller" (deepCopy $mergedControllerValues) -}}

  {{- if eq .Values.controller.type "rollout" }}
    {{ include "cf-common-0.24.0.controller.rollout" . | nindent 0 }}
    {{- if .Values.controller.rollout }}
      {{- if .Values.controller.rollout.analysisTemplate }}
        {{- if .Values.controller.rollout.analysisTemplate.enabled }}
      {{ include "cf-common-0.24.0.controller.analysis-template" . | nindent 0 }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- else if eq .Values.controller.type "deployment" }}
    {{ include "cf-common-0.24.0.controller.deployment" . | nindent 0 }}
  {{- else if eq .Values.controller.type "statefulset" }}
    {{ include "cf-common-0.24.0.controller.statefulset" . | nindent 0 }}
  {{- else if eq .Values.controller.type "job" }}
    {{ include "cf-common-0.24.0.controller.job" . | nindent 0 }}
  {{- else if eq .Values.controller.type "cronjob" }}
    {{ include "cf-common-0.24.0.controller.cronjob" . | nindent 0 }}
  {{- else }}
    {{ fail (printf "ERROR: %s is invalid controller type!" .Values.controller.type) }}
  {{- end }}
{{- end -}}

{{- end -}}
