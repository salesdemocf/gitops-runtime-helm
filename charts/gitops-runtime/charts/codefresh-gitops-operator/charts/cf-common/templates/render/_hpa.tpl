{{/*
Renders HorizontalPodAutoscaler template.
Must be called from chart root context.
Usage:
{{- include "cf-common-0.19.2.hpa" . -}}
*/}}

{{- define "cf-common-0.19.2.hpa" -}}

{{- if .Values.hpa.enabled -}}

{{- $defaultControllerValues := deepCopy .Values.controller -}}
{{- $globalControllerValues := dict -}}
{{- if .Values.global -}}
  {{- if .Values.global.controller -}}
    {{- $globalControllerValues = deepCopy .Values.global.controller -}}
  {{- end -}}
{{- end -}}
{{- $mergedControllerValues := mergeOverwrite $globalControllerValues $defaultControllerValues -}}
{{- $_ := set .Values "controller" (deepCopy $mergedControllerValues) -}}

apiVersion: {{ include "cf-common-0.19.2.apiVersion.autoscaling" . }}
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "cf-common-0.19.2.names.fullname" . }}
  labels: {{ include "cf-common-0.19.2.labels.standard" . | nindent 4 }}
spec:
  scaleTargetRef:
    {{- if eq .Values.controller.type "deployment" }}
    apiVersion: apps/v1
    kind: Deployment
    {{- else if eq .Values.controller.type "rollout" }}
    apiVersion: argoproj.io/v1alpha1
    kind: Rollout
    {{- end }}
    name: {{ include "cf-common-0.19.2.names.fullname" . }}
  minReplicas: {{ required "hpa.minReplicas is required!" .Values.hpa.minReplicas | int }}
  maxReplicas: {{ required "hpa.maxReplicas is required!" .Values.hpa.maxReplicas | int }}
  metrics:
{{- if .Values.hpa.metrics }}
{{ toYaml .Values.hpa.metrics | indent 4 }}
{{- end }}
{{- if (or .Values.hpa.targetMemoryUtilizationPercentage .Values.hpa.targetCPUUtilizationPercentage) }}
{{- with .Values.hpa.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ . | int }}
{{- end }}
{{- with .Values.hpa.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ . | int }}
{{- end }}
{{- else }}
  {{- fail (printf "ERROR: hpa.targetMemoryUtilizationPercentage or hpa.targetCPUUtilizationPercentage is required!" ) }}
{{- end }}

{{- end -}}

{{- end -}}
