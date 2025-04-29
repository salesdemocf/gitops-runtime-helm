{{/*
Renders ports map in container. Ports are obtained from .Values.service
Called from container template.
Usage:
ports: {{- include "cf-common-0.24.0.ports" $ | nindent }}
*/}}

{{- define "cf-common-0.24.0.ports" -}}

{{- $ports := list -}}
{{- range $serviceName, $serviceItem := .Values.service }}
  {{- range $portName, $portItem := .ports }}
  {{- $_ := set $portItem "name" $portName -}}
  {{- $ports = append $ports $portItem -}}
  {{- end }}
{{- end }}

{{- if $ports }}
ports:
{{- range $i, $port := $ports }}
- name: {{ $port.name }}
  containerPort: {{ $port.targetPort | default $port.port }}
  {{- if $port.protocol }}
    {{- if or ( eq $port.protocol "HTTP" ) ( eq $port.protocol "HTTPS") ( eq $port.protocol "TCP" ) }}
  protocol: TCP
    {{- else }}
  protocol: {{ $port.protocol }}
    {{- end }}
  {{- else }}
  protocol: TCP
  {{- end }}
{{- end }}

{{- end }}

{{- end -}}
