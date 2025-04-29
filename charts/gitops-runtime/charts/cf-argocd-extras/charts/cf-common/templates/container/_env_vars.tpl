{{/*
Renders env vars in container template.
Called from container template.
Usage:
env: {{ include "cf-common-0.24.0.env-vars" (dict "Values" .Values.container.env "context" $) | nindent }}
*/}}
{{- define "cf-common-0.24.0.env-vars"}}
{{- $ := .context }}
  {{- if .Values }}
    {{- if not (kindIs "map" .Values) }}
      {{ fail "ERROR: env block must be a map"}}
    {{- end }}
  {{- end }}
  {{- $env := .Values }}
  {{- $templatedEnv := include "cf-common-0.24.0.tplrender" (dict "Values" $env "context" $) | fromYaml }}
  {{- range $name, $val := $templatedEnv }}
    {{- if or (kindIs "string" $val) (kindIs "bool" $val) (kindIs "int" $val) (kindIs "float64" $val) }}
- name: {{ $name }}
  value: {{ $val | quote }}
    {{- else if kindIs "map" $val}}
      {{- if hasKey $val "valueFrom" }}
        {{- if or (hasKey $val.valueFrom "secretKeyRef") (hasKey $val.valueFrom "configMapKeyRef") (hasKey $val.valueFrom "fieldRef") }}
- name: {{ $name }}
{{- $val | toYaml | nindent 2 }}
        {{- else}}
          {{ fail "ERROR: Only secretKeyRef/configMapKeyRef/fieldRef are supported for valueFrom block for environment variables!" }}
        {{- end}}
      {{- else }}
        {{ fail "ERROR: Cannot generate environment variables only strings and valueFrom are supported!"}}
      {{- end }}
    {{- else }}
      {{ fail "ERROR: Only maps and string/int/bool are supported for environment variables!"}}
    {{- end }}
  {{- end }}
{{- end }}
