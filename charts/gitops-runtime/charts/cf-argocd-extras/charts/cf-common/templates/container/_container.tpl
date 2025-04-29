{{/*
Renders main container in pod template.
Called from pod template.
Usage:
{{ include "cf-common-0.24.0.container" (dict "Values" .Values.container "context" $) }}
*/}}
{{-  define "cf-common-0.24.0.container" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- $containerName := include "cf-common-0.24.0.names.fullname" $ -}}
{{- if and (hasKey .Values "nameOverride") .Values.nameOverride }}
{{- $containerName = include "cf-common-0.24.0.tplrender" (dict "Values" .Values.nameOverride "context" $) -}}
{{- end }}

- name: {{ $containerName }}
  image: {{ (include "cf-common-0.24.0.tplrender" (dict "Values" (include "cf-common-0.24.0.image.name" (dict "image" .Values.image "context" $)) "context" $)) }}
  imagePullPolicy: {{ .Values.image.pullPolicy | default "Always" }}

  {{- with .Values.command }}
    {{- if not (kindIs "slice" .) }}
      {{- fail "ERROR: container.command block must be a list!" }}
    {{- end }}
  command: {{- include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $) | nindent 2 }}
  {{- end }}

  {{- with .Values.args }}
    {{- if not (kindIs "slice" .) }}
      {{- fail "ERROR: container.args block must be a list!" }}
    {{- end }}
  args: {{ toYaml . | nindent 2 }}
  {{- end }}

  {{- with .Values.containerSecurityContext }}
    {{- if not (kindIs "map" .) }}
      {{- fail "ERROR: container.containerSecurityContext block must be a map!" }}
    {{- end }}
  securityContext: {{ toYaml . | nindent 4 }}
  {{- end }}

  {{- with .Values.lifecycle }}
    {{- if not (kindIs "map" .) }}
      {{- fail "ERROR: container.lifecycle block must be a map!" }}
    {{- end }}
  lifecycle: {{ toYaml . | nindent 4 }}
  {{- end }}

  {{- if or .Values.envFrom $.Values.secrets }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- if not (kindIs "slice" .) }}
        {{ fail "ERROR: container.envFrom block must be a list!"}}
      {{- end }}
      {{- include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $) | trim | nindent 4 }}
    {{- end }}
    {{- range $secretName, $secretItem := $.Values.secrets }}
      {{- if $secretItem.enabled }}
    - secretRef:
        name: {{ printf "%s-%s" (include "cf-common-0.24.0.names.fullname" $) $secretName }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{- if or (.Values.env) ($.Values.global.env) }}
    {{- $mergedEnv := .Values.env }}
{{- /*
For backward compatibility (.Values.env takes precedence over .Values.container.env)
*/}}
    {{- if $.Values.env }}
  {{- $mergedEnv = merge $.Values.env $mergedEnv }}
    {{- end }}
    {{- if $.Values.global.env }}
  {{- $mergedEnv = merge $mergedEnv $.Values.global.env }}
    {{- end }}
  env:
  {{- include "cf-common-0.24.0.env-vars" (dict "Values" $mergedEnv "context" $) | trim | nindent 2 }}
  
    {{- if .Values.extraEnv }}
  {{- include "cf-common-0.24.0.env-vars" (dict "Values" .Values.extraEnv "context" $) | trim | nindent 2 }}
    {{- end }}
    
  {{- end }}

  {{- include "cf-common-0.24.0.ports" $ | trim | nindent 2 }}

{{- /*
For backward compatibility (.Values.volumeMounts takes precedence over .Values.container.volumeMounts)
*/}}
  {{- $mergedVolumeMounts := .Values.volumeMounts }}
    {{- if $.Values.volumeMounts }}
  {{- $mergedVolumeMounts = mergeOverwrite $mergedVolumeMounts $.Values.volumeMounts }}
    {{- end }}
  volumeMounts: {{ include "cf-common-0.24.0.volumeMounts" (dict "Values" $mergedVolumeMounts "context" $) | trim | nindent 2 }}

  {{- with .Values.probes }}
  {{- include "cf-common-0.24.0.probes" . | trim | nindent 2 }}
  {{- end }}

  {{- with .Values.resources }}
    {{- if not (kindIs "map" .) }}
      {{- fail "ERROR: container.resources block must be a map!" }}
    {{- end }}
    {{- if $.Values.resources }}
  resources: {{ toYaml $.Values.resources | nindent 4 }}
    {{- else }}
  resources: {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}

{{- end -}}
