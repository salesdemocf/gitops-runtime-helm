{{/*
Renders statefulset template
Must be called from chart root context.
Usage:
{{ include "cf-common-0.24.0.controller.statefulset" . }}
*/}}

{{- define "cf-common-0.24.0.controller.statefulset" -}}

{{/*Merge .Values.controller with .Values.controller.statefulset*/}}
{{- $controllerValues := deepCopy .Values.controller -}}
{{- $stsValues := dict -}}
{{- if .Values.controller.statefulset -}}
    {{- $stsValues = deepCopy .Values.controller.statefulset -}}
{{- end -}}
{{- $mergedControllerValues := mergeOverwrite $controllerValues $stsValues -}}
{{- $_ := set .Values "controller" (deepCopy $mergedControllerValues) -}}

{{- $strategy := default "RollingUpdate" .Values.controller.strategy -}}
{{- $podManagementPolicy := default "OrderedReady" .Values.controller.podManagementPolicy -}}

{{- if and (ne $strategy "OnDelete") (ne $strategy "RollingUpdate") -}}
  {{- fail (printf "ERROR: %s is invalid controller strategy for Stateful Set!" $strategy) -}}
{{- end -}}

{{- if and (ne $podManagementPolicy "Parallel") (ne $podManagementPolicy "OrderedReady") -}}
  {{- fail (printf "ERROR: %s is invalid Stateful Set podManagementPolicy!" $podManagementPolicy) -}}
{{- end -}}

{{- $stsName := include "cf-common-0.24.0.names.fullname" . -}}
{{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
  {{- $stsName = printf "%v-%v" $stsName .Values.controller.nameOverride -}}
{{- end -}}

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ $stsName }}
  labels: {{ include "cf-common-0.24.0.labels.standard" . | nindent 4 }}
  {{- if .Values.controller.labels }}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.controller.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.controller.annotations }}
  annotations:
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.controller.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: {{ .Values.controller.revisionHistoryLimit | int | default 5 }}
  replicas: {{ coalesce .Values.controller.replicas .Values.replicaCount | int | default 1 }}
  podManagementPolicy: {{ default "OrderedReady" .Values.controller.podManagementPolicy }}
  selector:
    matchLabels: {{ include "cf-common-0.24.0.labels.matchLabels" . | nindent 6 }}
  serviceName: {{ include "cf-common-0.24.0.names.fullname" . }}
  updateStrategy:
    type: {{ $strategy }}
    {{- with .Values.controller.rollingUpdate }}
      {{- if and (eq $strategy "RollingUpdate") .partition }}
    rollingUpdate:
      partition: {{ .partition }}
      {{- end }}
    {{- end }}
  template:
    metadata:
      labels: {{ include "cf-common-0.24.0.labels.matchLabels" . | nindent 8 }}
      {{- if .Values.podLabels }}
      {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.podAnnotations }}
      annotations:
      {{- include "cf-common-0.24.0.tplrender" (dict "Values" .Values.podAnnotations "context" $) | nindent 8 }}
      {{- end }}
    spec: {{- include "cf-common-0.24.0.controller.pod" . | trim | nindent 6 }}
  volumeClaimTemplates:
  {{- range $claimIndex, $claimItem := .Values.volumeClaimTemplates }}
    {{- if not (eq $claimItem.enabled false ) }}
    - metadata:
        name: {{ $claimIndex }}
        {{- with ($claimItem.labels | default dict) }}
        labels: {{- include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $) | nindent 10 }}
        {{- end }}
        {{- with ($claimItem.annotations | default dict) }}
        annotations: {{- include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $) | nindent 10 }}
        {{- end }}
      spec:
        {{- $claimSize := required (printf "size is required for PVC %v" $claimItem.name) $claimItem.size }}
        accessModes:
          - {{ required (printf "accessMode is required for volumeClaimTemplate %v" $claimItem.name) $claimItem.accessMode  | quote }}
        resources:
          requests:
            storage: {{ $claimSize | quote }}
        {{ include "cf-common-0.24.0.storageclass" ( dict "persistence" $claimItem "context" $) }}
      {{- end }}
    {{- end }}
{{- end -}}
