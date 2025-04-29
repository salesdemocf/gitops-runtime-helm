{{/*
Renders Service Monitor objects.
*/}}

{{- define "cf-common-0.24.0.podMonitor" -}}

{{- range $podMonitorIndex, $podMonitorItem := .Values.podMonitor -}}

{{- $podMonitorName := include "cf-common-0.24.0.names.fullname" $ -}}
{{- if and (hasKey $podMonitorItem "nameOverride") $podMonitorItem.nameOverride -}}
  {{- $podMonitorName = printf "%v-%v" $podMonitorName $podMonitorItem.nameOverride -}}
{{- end -}}
{{- if and (hasKey $podMonitorItem "fullnameOverride") $podMonitorItem.fullnameOverride -}}
  {{- $podMonitorName = $podMonitorItem.fullnameOverride -}}
{{- end -}}

  {{- if $podMonitorItem.enabled }}
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: {{ $podMonitorName }}
  labels: {{ include "cf-common-0.24.0.labels.standard" $ | nindent 4 }}
  {{- if $podMonitorItem.labels }}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" $podMonitorItem.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if $podMonitorItem.annotations }}
  annotations: {{- include "cf-common-0.24.0.tplrender" (dict "Values" $podMonitorItem.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  selector:
    {{- if $podMonitorItem.selector }}
    {{- include "cf-common-0.24.0.tplrender" (dict "Values" $podMonitorItem.selector "context" $) | nindent 4 }}
    {{- else }}
    matchLabels:
      {{- include "cf-common-0.24.0.labels.matchLabels" $ | nindent 6 }}
    {{- end }}
  {{- if $podMonitorItem.namespaceSelector }}
  namespaceSelector:
    {{- include "cf-common-0.24.0.tplrender" (dict "Values" $podMonitorItem.namespaceSelector "context" $) | nindent 6 }}
  {{- else }}
  namespaceSelector:
    matchNames:
      - {{ $.Release.Namespace }}
  {{- end }}
  podMetricsEndpoints: {{- toYaml ( required (printf "podMetricsEndpoints are required for podMonitor %v" $podMonitorName) $podMonitorItem.podMetricsEndpoints ) | nindent 4 }}
{{- end }}
  {{- end -}}

{{- end -}}
