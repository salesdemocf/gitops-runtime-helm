{{/*
Renders Services objects.
Must be called from chart root context.
Usage:
{{- include "cf-common-0.24.0.service" . -}}
*/}}

{{- define "cf-common-0.24.0.service" }}

{{- if not (kindIs "map" .Values.service) }}
  {{- fail "ERROR: service block must be a map!" }}
{{- end }}

{{- $primary := include "cf-common-0.24.0.service.primary" (dict "values" .Values.service) -}}

{{- range $serviceIndex, $serviceItem := .Values.service }}

{{- $serviceName := "" -}}
{{- $serviceType := $serviceItem.type | default "ClusterIP" -}}

{{- if not (or (eq "ClusterIP" $serviceType) (eq "NodePort" $serviceType) (eq "LoadBalancer" $serviceType)) -}}
  {{ fail ( printf "ERROR: service.%s.type is invalid service type!" $serviceIndex ) }}
{{- end -}}

{{- if eq $serviceIndex $primary }}
  {{- $serviceName = include "cf-common-0.24.0.names.fullname" $ -}}
{{- else }}
  {{- $serviceName = printf "%s-%s" (include "cf-common-0.24.0.names.fullname" $) $serviceIndex -}}
{{- end }}

  {{- if $serviceItem.enabled }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ $serviceName }}
  labels: {{ include "cf-common-0.24.0.labels.standard" $ | nindent 4 }}
  {{- if $serviceItem.labels }}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" $serviceItem.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if $serviceItem.annotations }}
  annotations: {{- include "cf-common-0.24.0.tplrender" (dict "Values" $serviceItem.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  type: {{ $serviceType }}
  {{- if and (eq $serviceType "ClusterIP") $serviceItem.clusterIP }}
  clusterIP: {{ $serviceItem.clusterIP }}
  {{- end }}
  {{- if and (eq $serviceType "LoadBalancer") $serviceItem.loadBalancerIP }}
  loadBalancerIP: {{ $serviceItem.loadBalancerIP }}
  {{- end }}
  {{- if and (eq $serviceType "LoadBalancer") $serviceItem.loadBalancerClass }}
  loadBalancerClass: {{ $serviceItem.loadBalancerClass }}
  {{- end }}
  {{- if and (eq $serviceType "LoadBalancer") $serviceItem.loadBalancerSourceRanges }}
  loadBalancerSourceRanges: {{ toYaml $serviceItem.loadBalancerSourceRanges | nindent 4 }}
  {{- end }}
  {{- with $serviceItem.externalIPs }}
  externalIPs: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- if $serviceItem.sessionAffinity }}
  sessionAffinity: {{ $serviceItem.sessionAffinity }}
  {{- end }}
  {{- with $serviceItem.externalIPs }}
  sessionAffinityConfig: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- if or (eq $serviceType "LoadBalancer") (eq $serviceType "NodePort") }}
  externalTrafficPolicy: {{ $serviceItem.externalTrafficPolicy | quote }}
  {{- end }}
  ports:
    {{- range $portName, $portItem := $serviceItem.ports }}
    - port: {{ required (printf "service.%s.ports.%s.port number is required!" $serviceIndex $portName) $portItem.port }}
      targetPort: {{ $portItem.targetPort | default $portName }}
      name: {{ $portName }}
      {{- if $portItem.protocol }}
        {{- if or ( eq $portItem.protocol "HTTP" ) ( eq $portItem.protocol "HTTPS") ( eq $portItem.protocol "TCP" ) }}
      protocol: TCP
        {{- else if or ( eq $portItem.protocol "UDP" ) ( eq $portItem.protocol "SCTP" ) }}
      protocol: {{ $portItem.protocol }}
        {{- else }}
          {{ fail (printf "ERROR: service.%s.ports.%s.protocol is invalid!" $serviceIndex $portName) }}
        {{- end }}
      {{- else }}
      protocol: TCP
      {{- end }}
      {{- if and (eq $serviceType "NodePort") (not (empty $serviceItem.nodePort)) }}
      nodePort: {{ $portItem.nodePort }}
      {{- end }}
    {{- end }}
  selector: {{ include "cf-common-0.24.0.labels.matchLabels" $ | nindent 4 }}
    {{- if $serviceItem.extraSelectorLabels }}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" $serviceItem.extraSelectorLabels "context" $) | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end }}

{{- end -}}
