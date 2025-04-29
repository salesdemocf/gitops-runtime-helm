{{/*
Renders pod spec.
Called from contoller template.
Usage:
{{ include "cf-common-0.24.0.controller.pod" . }}
*/}}
{{- define "cf-common-0.24.0.controller.pod" -}}

{{- include "cf-common-0.24.0.image.pullSecrets" . }}

serviceAccountName: {{ include "cf-common-0.24.0.names.serviceAccountName" . }}

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
    {{- include "cf-common-0.24.0.container" (dict "Values" $initContainerItem "context" $) | trim | nindent 0 }}
    {{- end }}
  {{- end }}
{{- end }}

{{- with .Values.container }}
containers: {{ include "cf-common-0.24.0.container" (dict "Values" . "context" $) | trim | nindent 0 }}
{{- end }}
{{- with .Values.additionalContainers }}
{{ toYaml . | nindent 0 }}
{{- end }}

volumes:  {{ include "cf-common-0.24.0.volumes" (dict "Values" .Values.volumes "context" $) | trim | nindent 0 }}

{{- with .Values.extraVolumes }}
{{ include "cf-common-0.24.0.volumes" (dict "Values" . "context" $) | trim }}
{{- end }}

{{- with .Values.hostAliases }}
hostAliases: {{ toYaml . | nindent 2 }}
{{- end }}

{{- $nodeSelector := .Values.nodeSelector | default dict }}
{{- $globalNodeSelector := .Values.global.nodeSelector | default dict }}
{{- if or (not (kindIs "map" $nodeSelector)) (not (kindIs "map" $globalNodeSelector)) }}
  {{- fail "ERROR: nodeSelector block must be a map!" }}
{{- end }}
{{- $allNodeSelector := mergeOverwrite $globalNodeSelector $nodeSelector }}
{{- with $allNodeSelector }}
nodeSelector: {{ toYaml . | nindent 2 }}
{{- end }}

{{- $tolerations := .Values.tolerations | default list }}
{{- $globalTolerations := .Values.global.tolerations | default list }}
{{- if or (not (kindIs "slice" $tolerations)) (not (kindIs "slice" $globalTolerations)) }}
  {{- fail "ERROR: tolerations block must be a list!" }}
{{- end }}
{{- $allToleration := concat $globalTolerations $tolerations }}
{{- with $allToleration }}
tolerations: {{ toYaml . | nindent 2 }}
{{- end }}

{{- $affinity := .Values.affinity | default dict }}
{{- $globalAffinity := .Values.global.affinity | default dict }}
{{- if or (not (kindIs "map" $affinity)) (not (kindIs "map" $globalAffinity)) }}
  {{- fail "ERROR: affinity block must be a map!" }}
{{- end }}
{{- $allAffinity := mergeOverwrite $globalAffinity $affinity }}
{{- with $allAffinity }}
affinity: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.topologySpreadConstraints }}
topologySpreadConstraints: {{- include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $) | nindent 2 }}
{{- end }}

{{- with .Values.controller.restartPolicy }}
restartPolicy: {{ . }}
{{- end }}

{{- end }}
