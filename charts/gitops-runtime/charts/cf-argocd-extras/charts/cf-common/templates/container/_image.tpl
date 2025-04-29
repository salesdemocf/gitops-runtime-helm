{{/*
Prints full image name.
Called from container template.
Usage:
{{ include "cf-common-0.24.0.image.name" (dict "image" .Values.container.image "context" $) }}
*/}}
{{- define "cf-common-0.24.0.image.name" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- $registryName := .image.registry -}}
{{- $repositoryName := .image.repository -}}
{{- $imageTag := .image.tag | toString -}}
{{- $imageDigest := .image.digest }}

{{- if $.Values.global -}}
  {{- if $.Values.global.imageRegistry -}}
    {{ $registryName = $.Values.global.imageRegistry }}
  {{- end -}}
{{- end -}}

{{- /*
For backward compatibility with legacy var struct
e.g.:
cf-api:
  enabled: true
  image: codefresh/cf-api
  dockerRegistry: gcr.io/codefresh-enterprise/
  imageTag: latest
*/}}
{{- if $.Values.dockerRegistry -}}
{{- $registryName = $.Values.dockerRegistry | trimSuffix "/" -}}
{{- end -}}
{{- if and $.Values.image (kindIs "string" $.Values.image ) -}}
{{- $repositoryName = $.Values.image -}}
{{- end -}}
{{- if $.Values.imageTag -}}
{{- $imageTag = $.Values.imageTag | toString -}}
{{- end -}}

{{- /*
For backward compatibility (onprem with private docker registry)
*/}}
{{- if $.Values.global -}}
  {{- if and $.Values.global.privateRegistry $.Values.global.dockerRegistry -}}
    {{ $registryName = $.Values.global.dockerRegistry | trimSuffix "/" }}
  {{- end -}}
{{- end -}}

{{- if $registryName -}}
  {{- if $imageDigest }}
    {{- printf "%s/%s:%s@%s" $registryName $repositoryName $imageTag $imageDigest -}}
  {{- else }}
    {{- printf "%s/%s:%s" $registryName $repositoryName $imageTag -}}
  {{- end }}
{{- else }}
  {{- if $imageDigest }}
    {{- printf "%s:%s@%s" $repositoryName $imageTag $imageDigest -}}
  {{- else }}
    {{- printf "%s:%s" $repositoryName $imageTag -}}
  {{- end }}
{{- end }}

{{- end -}}

{{/*
Prints full image name.
Must be called from chart root context.
Usage:
{{ include "cf-common-0.24.0.image.pullSecrets" . }}
*/}}
{{- define "cf-common-0.24.0.image.pullSecrets" -}}
  {{- $pullSecrets := list }}

  {{- if .Values.global.imagePullSecrets }}
    {{- if not (kindIs "slice" .Values.global.imagePullSecrets) -}}
    {{- fail "ERROR: imagePullSecrets block must be a list!" -}}
    {{- end -}}

    {{- range .Values.global.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets (include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $)) -}}
    {{- end -}}
  {{- end -}}

  {{- if .Values.imagePullSecrets }}
    {{- if not (kindIs "slice" .Values.imagePullSecrets) -}}
    {{- fail "ERROR: imagePullSecrets block must be a list!" -}}
    {{- end -}}

    {{- range .Values.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets (include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $)) -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
    {{- range $pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
