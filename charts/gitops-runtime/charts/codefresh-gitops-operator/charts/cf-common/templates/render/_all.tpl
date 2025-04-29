{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.19.2.all" -}}

{{- include "cf-common-0.19.2.controller" . -}}
{{- include "cf-common-0.19.2.service" . -}}
{{- include "cf-common-0.19.2.configmaps" . -}}
{{- include "cf-common-0.19.2.secrets" . -}}
{{- include "cf-common-0.19.2.serviceaccount" . -}}
{{- include "cf-common-0.19.2.rbac" . -}}
{{- include "cf-common-0.19.2.pvc" . -}}

{{- end -}}
