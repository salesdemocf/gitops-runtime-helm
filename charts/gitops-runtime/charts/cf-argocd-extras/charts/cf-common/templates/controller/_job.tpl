{{/*
Renders job template.
Must be called from chart root context.
Usage:
{{ include "cf-common-0.24.0.controller.job" . }}
*/}}

{{- define "cf-common-0.24.0.controller.job" -}}

---
apiVersion: batch/v1
kind: Job
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
  {{- if .Values.controller.job.suspend }}
  suspend: {{ .Values.controller.job.suspend }}
  {{- end }}
  {{- with .Values.controller.job.activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ . | int }}
  {{- end }}
  {{- with .Values.controller.job.backoffLimit }}
  backoffLimit: {{ . | int }}
  {{- end }}
  {{- with .Values.controller.job.completions }}
  completions: {{ . | int }}
  {{- end }}
  {{- with .Values.controller.job.parallelism }}
  parallelism: {{ . | int }}
  {{- end }}
  {{- if .Values.controller.job.manualSelector }}
  manualSelector: {{ .Values.controller.job.manualSelector }}
    {{- if .Values.controller.job.selector }}
  selector:
    matchLabels: {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.controller.job.selector "context" $) | nindent 6 }}
    {{- else }}
    {{ fail (printf "ERROR: manualSelector is enabled! Specify `.job.selector` labels!") }}
    {{- end }}
  {{- end }}
  template:
    metadata:
      labels: {{ include "cf-common-0.24.0.labels.matchLabels" . | nindent 8 }}
      {{- if .Values.podLabels }}
      {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 8 }}
      {{- end }}
      {{- with include "cf-common-0.24.0.annotations.podAnnotations" . }}
      annotations:
        {{- . | nindent 8 }}
      {{- end }}
    spec: {{- include "cf-common-0.24.0.controller.pod" . | trim | nindent 6 -}}
  {{- with .Values.controller.job.ttlSecondsAfterFinished }}
  ttlSecondsAfterFinished: {{ . }}
  {{- end }}
{{- end -}}
