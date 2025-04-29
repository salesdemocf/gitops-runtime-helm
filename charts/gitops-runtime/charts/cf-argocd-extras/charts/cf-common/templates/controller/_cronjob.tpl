{{/*
Renders cronjob template.
Must be called from chart root context.
Usage:
{{ include "cf-common-0.24.0.controller.cronjob" . }}
*/}}

{{- define "cf-common-0.24.0.controller.cronjob" -}}

---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ include "cf-common-0.24.0.names.fullname" . }}
  labels: {{ include "cf-common-0.24.0.labels.standard" . | nindent 4 }}
  {{- if .Values.controller.labels }}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.controller.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.controller.annotations }}
  annotations:
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.controller.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  concurrencyPolicy: {{ .Values.controller.cronjob.concurrencyPolicy }}
  startingDeadlineSeconds: {{ .Values.controller.cronjob.startingDeadlineSeconds }}
  schedule: {{ .Values.controller.cronjob.schedule | quote }}
  successfulJobsHistoryLimit: {{ .Values.controller.cronjob.successfulJobsHistory }}
  failedJobsHistoryLimit: {{ .Values.controller.cronjob.failedJobsHistory }}
  {{- with .Values.controller.cronjob.suspend }}
  suspend: {{ . }}
  {{- end }}
  jobTemplate:
    spec:
      {{- with .Values.controller.cronjob.activeDeadlineSeconds }}
      activeDeadlineSeconds: {{ . | int }}
      {{- end }}
      {{- with .Values.controller.cronjob.backoffLimit }}
      backoffLimit: {{ . | int }}
      {{- end }}
      {{- with .Values.controller.cronjob.completions }}
      completions: {{ . | int }}
      {{- end }}
      {{- with .Values.controller.cronjob.parallelism }}
      parallelism: {{ . | int }}
      {{- end }}
      template:
        metadata:
          labels: {{ include "cf-common-0.24.0.labels.matchLabels" . | nindent 12 }}
          {{- if .Values.podLabels }}
          {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 12 }}
          {{- end }}
          {{- with include "cf-common-0.24.0.annotations.podAnnotations" . }}
          annotations:
            {{- . | nindent 12 }}
          {{- end }}
        spec: {{- include "cf-common-0.24.0.controller.pod" . | trim | nindent 10 -}}
      {{- with .Values.controller.cronjob.ttlSecondsAfterFinished }}
      ttlSecondsAfterFinished: {{ . }}
      {{- end }}
{{- end -}}
