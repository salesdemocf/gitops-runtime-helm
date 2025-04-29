{{/*
Renders Extra objects defined at .Values.extraResources
Must be called from chart root context.
Usage:
{{- include "cf-common-0.24.0.extraResources" . -}}
*/}}

{{- define "cf-common-0.24.0.extraResources" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- range .Values.extraResources }}
{{ include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $) }}
{{- end }}

{{- end -}}
