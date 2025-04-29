{{/*
Render checksum annotation
Must be called from chart root context.
Usage:
annotations: {{ include "cf-common-0.24.0.annotations.podAnnotations" . | nindent }}
*/}}
{{- define "cf-common-0.24.0.annotations.podAnnotations" -}}

{{- if .Values.podAnnotations -}}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.podAnnotations "context" $) | nindent 0 }}
{{- end -}}

{{- $configMapFound := dict -}}
{{- range $configMapIndex, $configMapItem := .Values.configMaps -}}

  {{- if $configMapItem.enabled -}}
    {{- $_ := set $configMapFound $configMapIndex ( include "cf-common-0.24.0.tplrender" (dict "Values" $configMapItem.data "context" $) | sha256sum) -}}
  {{- end -}}

  {{- if $configMapFound -}}
    {{- printf "checksum/config: %v" (toYaml $configMapFound | sha256sum) | nindent 0 -}}
  {{- end -}}

{{- end -}}

{{- $secretFound := dict -}}
{{- range $secretIndex, $secretItem := .Values.secrets -}}

  {{- if $secretItem.enabled -}}
    {{- $_ := set $secretFound $secretIndex ( include "cf-common-0.24.0.tplrender" (dict "Values" $secretItem.stringData "context" $) | sha256sum) -}}
  {{- end -}}

  {{- if $secretFound -}}
    {{- printf "checksum/secret: %v" (toYaml $secretFound | sha256sum) | nindent 0 -}}
  {{- end -}}

{{- end -}}

{{- end -}}
