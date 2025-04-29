{{/*
Expand the name of the chart.
*/}}
{{- define "cf-common-0.24.0.names.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cf-common-0.24.0.names.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cf-common-0.24.0.names.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
ServiceAccount Name
*/}}
{{- define "cf-common-0.24.0.names.serviceAccountName" -}}
  {{- if .Values.serviceAccount -}}
    {{- if .Values.serviceAccount.enabled -}}
      {{- .Values.serviceAccount.nameOverride | default (include "cf-common-0.24.0.names.fullname" .)  -}}
    {{- else -}}
      {{- print "default" -}}
    {{- end -}}
  {{- else -}}
    {{- print "default" -}}
  {{- end -}}
{{- end -}}
