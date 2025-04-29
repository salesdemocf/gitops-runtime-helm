{{/*
Renders pod spec.
Called from contoller template.
Usage:
{{ include "cf-common-0.19.2.controller.pod" . }}
*/}}
{{- define "cf-common-0.19.2.controller.pod" -}}

{{- include "cf-common-0.19.2.image.pullSecrets" . }}

serviceAccountName: {{ include "cf-common-0.19.2.names.serviceAccountName" . }}

automountServiceAccountToken: {{ .Values.automountServiceAccountToken | default true }}

{{- with .Values.podSecurityContext }}
  {{- if not (kindIs "map" .) }}
    {{- fail "ERROR: podSecurityContext block must be a map!" }}
  {{- end }}
{{- if not (eq .enabled false ) }}
securityContext: {{ omit . "enabled" | toYaml | nindent 2 }}
{{- end }}
{{- end }}

{{- with .Values.priorityClassName }}
priorityClassName: {{ . }}
{{- end }}

{{- with .Values.runtimeClassName }}
runtimeClassName: {{ . }}
{{- end }}

{{- with .Values.schedulerName }}
schedulerName: {{ . }}
{{- end }}

{{- with .Values.hostNetwork }}
hostNetwork: {{ . }}
{{- end }}

{{- if .Values.dnsPoliicy }}
dnsPolicy: {{ .Values.dnsPolicy }}
{{- else if .Values.hostNetwork }}
dnsPolicy: ClusterFirstWithHostNet
{{- else }}
dnsPolicy: ClusterFirst
{{- end }}

{{- with .Values.dnsConfig }}
dnsConfig: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
{{- end }}

{{- if .Values.initContainers }}
initContainers:
  {{- range $initContainerIndex, $initContainerItem := .Values.initContainers }}
    {{- if $initContainerItem.enabled }}
    {{- $_ := set $initContainerItem "nameOverride" $initContainerIndex }}
    {{- include "cf-common-0.19.2.container" (dict "Values" $initContainerItem "context" $) | trim | nindent 0 }}
    {{- end }}
  {{- end }}
{{- end }}

{{- with .Values.container }}
containers: {{ include "cf-common-0.19.2.container" (dict "Values" . "context" $) | trim | nindent 0 }}
{{- end }}
{{- with .Values.additionalContainers }}
{{ toYaml . | nindent 0 }}
{{- end }}

volumes:  {{ include "cf-common-0.19.2.volumes" (dict "Values" .Values.volumes "context" $) | trim | nindent 0 }}

{{- with .Values.extraVolumes }}
{{ include "cf-common-0.19.2.volumes" (dict "Values" . "context" $) | trim }}
{{- end }}

{{- with .Values.hostAliases }}
hostAliases: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.nodeSelector }}
  {{- if not (kindIs "map" .) }}
    {{- fail "ERROR: nodeSelector block must be a map!" }}
  {{- end }}
nodeSelector: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.tolerations }}
  {{- if not (kindIs "slice" .) }}
    {{- fail "ERROR: tolerations block must be a list!" }}
  {{- end }}
tolerations: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.affinity }}
  {{- if not (kindIs "map" .) }}
    {{- fail "ERROR: affinity block must be a map!" }}
  {{- end }}
affinity: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.topologySpreadConstraints }}
topologySpreadConstraints: {{- include "cf-common-0.19.2.tplrender" (dict "Values" . "context" $) | nindent 2 }}
{{- end }}

{{- with .Values.controller.restartPolicy }}
restartPolicy: {{ . }}
{{- end }}

{{- end }}
