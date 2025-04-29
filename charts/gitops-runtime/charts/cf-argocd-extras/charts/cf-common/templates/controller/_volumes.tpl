{{/*
Renders volumes in controller template.
Called from pod template.
Usage:
volumes: {{ include "cf-common-0.24.0.volumes" (dict "Values" .Values.volumes "context" $) | nindent }}
*/}}

{{- define "cf-common-0.24.0.volumes" -}}
{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- $defaultVolumes := dict -}}
{{- $globalVolumes := dict -}}

{{- if .Values -}}
  {{- $defaultVolumes = deepCopy .Values -}}
{{- end -}}
{{- if $.Values.global -}}
  {{- if $.Values.global.volumes -}}
    {{- $globalVolumes = deepCopy $.Values.global.volumes -}}
  {{- end -}}
{{- end -}}
{{- $mergedVolumes := mergeOverwrite $globalVolumes $defaultVolumes -}}

{{- range $volumeIndex, $volumeItem := $mergedVolumes }}

  {{- if $volumeItem.enabled }}
- name: {{ $volumeIndex }}
  {{- $volumeName := printf "%s-%s" (include "cf-common-0.24.0.names.fullname" $) $volumeIndex -}}

  {{- if and (or (hasKey $volumeItem "existingName") (hasKey $volumeItem "nameOverride")) (or $volumeItem.existingName $volumeItem.nameOverride) }}
  {{- $volumeName = include "cf-common-0.24.0.tplrender" (dict "Values" (coalesce $volumeItem.nameOverride $volumeItem.existingName) "context" $) -}}
  {{- end }}

  {{- if eq $volumeItem.type "configMap" }}
  configMap:
    name: {{ $volumeName }}
  {{- with $volumeItem.optional }}
    optional: {{ . }}
  {{- end }}

  {{- else if eq $volumeItem.type "secret" }}
  secret:
    secretName: {{ $volumeName }}
  {{- with $volumeItem.optional }}
    optional: {{ . }}
  {{- end }}
  {{- with $volumeItem.defaultMode }}
    defaultMode: {{ . }}
  {{- end }}
  {{- with $volumeItem.items }}
    items: {{ toYaml . | nindent 4 }}
  {{- end }}

  {{- else if eq $volumeItem.type "pvc" }}
  persistentVolumeClaim:
    claimName: {{ $volumeName }}

  {{- else if eq $volumeItem.type "emptyDir" }}
    {{- if or ($volumeItem.sizeLimit) ($volumeItem.medium) }}
  emptyDir:
    {{- with $volumeItem.sizeLimit }}
    sizeLimit: {{ . }}
    {{- end -}}
    {{- with $volumeItem.medium }}
    medium: {{ . }}
    {{- end -}}
    {{- else }}
  emptyDir: {}
    {{- end }}

  {{- else }}
    {{ fail (printf "ERROR: %s is invalid volume type for volume %s!" $volumeItem.type $volumeIndex) }}
  {{- end }}

  {{- end }}

{{- end }}

{{- end -}}
