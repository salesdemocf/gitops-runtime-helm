{{- define "cf-common-0.19.2.keda.scaled-object" }}
{{- if .Values.keda.enabled }}

{{- if and .Values.hpa.enabled }}
{{- fail "ERROR: Both KEDA ScaledObject and HPA are enabled. Disable HPA or Keda ScaledObject!" }}
{{- end }}

{{- $controllerName := include "cf-common-0.19.2.names.fullname" . -}}
  {{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
    {{- $controllerName = printf "%v-%v" $controllerName .Values.controller.nameOverride -}}
  {{- end -}}
{{- $containerName := include "cf-common-0.19.2.names.fullname" . -}}
  {{- if and (hasKey .Values.container "nameOverride") .Values.container.nameOverride }}
    {{- $containerName = include "cf-common-0.19.2.tplrender" (dict "Values" .Values.container.nameOverride "context" .) -}}
  {{- end }}

apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ include "cf-common-0.19.2.names.fullname" . }}
  labels: {{ include "cf-common-0.19.2.labels.standard" . | nindent 4 }}
  annotations:
  {{- with .Values.keda.spec.annotations }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with .Values.keda.spec.scaleTargetRef }}
  scaleTargetRef: {{ toYaml . | nindent 4 }}
  {{- else }}
  scaleTargetRef:
    {{- if eq .Values.controller.type "rollout" }}
    apiVersion: argoproj.io/v1alpha1
    kind: Rollout
    {{- else if eq .Values.controller.type "deployment" }}
    apiVersion: apps/v1
    kind: Deployment
    {{- else }}
    {{- required "Controller type is required! Only rollout/deployment is allowed!" .Values.controller.type }}
    {{- end }}
    name: {{ $controllerName }}
    envSourceContainerName: {{ .Values.keda.spec.envSourceContainerName | default $containerName }}
  {{- end }}
  pollingInterval: {{ .Values.keda.spec.pollingInterval | default 30 }}
  cooldownPeriod: {{ .Values.keda.spec.cooldownPeriod | default 300 }}
  {{- with .Values.keda.spec.idleReplicaCount }}
  idleReplicaCount: 0
  {{- end }}
  minReplicaCount: {{ .Values.keda.spec.minReplicaCount | default 1 }}
  maxReplicaCount: {{ .Values.keda.spec.maxReplicaCount | default 100 }}
  {{- if .Values.keda.spec.fallback }}
  fallback:
    failureThreshold: {{ required "Values.keda.spec.fallback.failureThreshold is required!" .Values.keda.spec.fallback.failureThreshold }}
    replicas: {{ required "Values.keda.spec.fallback.replicas is required!" .Values.keda.spec.fallback.replicas }}
  {{- end }}
  {{- with .Values.keda.spec.advanced }}
  advanced:
    restoreToOriginalReplicaCount: {{ .restoreToOriginalReplicaCount | default false }}
    horizontalPodAutoscalerConfig:
      name: {{ include "cf-common-0.19.2.names.fullname" . }}
      {{- with .horizontalPodAutoscalerConfig }}
        {{- toYaml . | nindent 6 }}
      {{- end -}}
  {{- end }}
  triggers:
  {{- range $triggerIndex, $triggerItem := .Values.keda.spec.triggers }}
  - type: {{ $triggerItem.type }}
    metadata: {{ $triggerItem.metadata | toYaml | nindent 6 }}
    {{- with $triggerItem.metricType }}
    metricType: {{ . }}
    {{- end }}
    {{- if and $.Values.keda.auth.enabled }}
    authenticationRef:
      name: {{ include "cf-common-0.19.2.names.fullname" $ }}
    {{- end }}
  {{ end }}
{{- end }}
{{- end }}

