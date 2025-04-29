{{/*
Return the primary service object.
Called from ingress template.
Usage:
{{ include "cf-common-0.19.2.service.primary" (dict "values" .Values.service) }}
*/}}
{{- define "cf-common-0.19.2.service.primary" -}}
  {{- $result := "" -}}

  {{- range $name, $service := .values -}}
    {{- if and (hasKey $service "primary") $service.primary $service.enabled -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys .values | first -}}
  {{- end -}}
  {{- $result -}}

{{- end -}}
