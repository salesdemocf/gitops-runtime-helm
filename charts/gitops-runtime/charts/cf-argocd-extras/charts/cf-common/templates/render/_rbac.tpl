{{/*
Renders ServiceAccount/Role/RoleBinding objects.
Must be called from chart root context.
Usage:
{{- include "cf-common-0.24.0.rbac" . -}}
*/}}

{{- define "cf-common-0.24.0.rbac" -}}

{{- if .Values.serviceAccount.enabled }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ default ( include "cf-common-0.24.0.names.fullname" $) .Values.serviceAccount.nameOverride }}
  labels: {{ include "cf-common-0.24.0.labels.standard" . | nindent 4 }}
  {{- if .Values.serviceAccount.annotations }}
  annotations: {{ include "cf-common-0.24.0.tplrender" (dict "Values" .Values.serviceAccount.annotations "context" $) | nindent 4 }}
  {{- end }}
secrets:
  - name: {{ include "cf-common-0.24.0.names.fullname" $ }}-sa-token
{{- end }}


{{- if and .Values.serviceAccount.enabled .Values.rbac.enabled  }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: {{ .Values.rbac.namespaced | ternary "Role" "ClusterRole" }}
metadata:
  name: {{ include "cf-common-0.24.0.names.fullname" $ }}
  labels: {{ include "cf-common-0.24.0.labels.standard" . | nindent 4 }}
rules: {{ include "cf-common-0.24.0.tplrender" (dict "Values" .Values.rbac.rules "context" $) | nindent 2 }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: {{ .Values.rbac.namespaced | ternary "RoleBinding" "ClusterRoleBinding" }}
metadata:
  name: {{ include "cf-common-0.24.0.names.fullname" $ }}
  labels: {{ include "cf-common-0.24.0.labels.standard" . | nindent 4 }}
roleRef:
  kind: {{ .Values.rbac.namespaced | ternary "Role" "ClusterRole" }}
  name: {{ include "cf-common-0.24.0.names.fullname" $ }}
  apiGroup: rbac.authorization.k8s.io
subjects:
  - kind: ServiceAccount
    name: {{ default ( include "cf-common-0.24.0.names.fullname" $) .Values.serviceAccount.nameOverride }}
    namespace: {{ .Release.Namespace }}
{{- end }}

{{- if .Values.serviceAccount.enabled }}
  {{- if .Values.serviceAccount.secret }}
    {{- if .Values.serviceAccount.secret.enabled }}
---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: {{ include "cf-common-0.24.0.names.fullname" $ }}-sa-token
  annotations:
    kubernetes.io/service-account.name: {{ default ( include "cf-common-0.24.0.names.fullname" $) .Values.serviceAccount.nameOverride }}
    {{- end }}
  {{- end }}
{{- end }}

{{- end -}}
