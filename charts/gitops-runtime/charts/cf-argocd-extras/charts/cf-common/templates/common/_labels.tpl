{{/*
Kubernetes standard labels
*/}}
{{- define "cf-common-0.24.0.labels.standard" -}}
app.kubernetes.io/name: {{ include "cf-common-0.24.0.names.name" . }}
helm.sh/chart: {{ include "cf-common-0.24.0.names.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "cf-common-0.24.0.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "cf-common-0.24.0.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
  {{- if .Values.fullnameOverride }}
app.kubernetes.io/component: {{ include "cf-common-0.24.0.names.fullname" . }}
  {{- end }}
{{- end -}}


{{/*
Extra labels
Usage:
{{ include "cf-common-0.24.0.labels.extraLabels" ( dict "Values" .Values.path.to.the.labels "context" $) }}
*/}}
{{- define "cf-common-0.24.0.labels.extraLabels" -}}
  {{- if not (kindIs "map" .Values) -}}
  {{- fail "ERROR: labels block must be a map" -}}
  {{- end -}}
  {{- with .Values -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}

{{/*
Annotations
Usage:
{{ include "cf-common-0.24.0.annotations" ( dict "Values" .Values.path.to.the.annotations "context" $) }}
*/}}
{{- define "cf-common-0.24.0.annotations" -}}
  {{- if not (kindIs "map" .Values) -}}
  {{- fail "ERROR: annotations block must be a map" -}}
  {{- end -}}
  {{- with .Values -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}
