{{/*
Return the primary port for a given Service object.
Called from ingress template.
Usage:
{{ include "cf-common-0.24.0.service.primaryPort" (dict "values" .Values.service.main ) }}
*/}}
{{- define "cf-common-0.24.0.service.primaryPort" -}}
  {{- $result := "" -}}
  {{- range $name, $port := .values.ports -}}
    {{- if and (hasKey $port "primary") $port.primary -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys .values.ports | first -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}
