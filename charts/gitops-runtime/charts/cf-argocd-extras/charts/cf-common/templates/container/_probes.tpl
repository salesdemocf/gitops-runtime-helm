{{/*
Renders probes map in container.
Called from container template.
Usage:
probes: {{ include "cf-common-0.24.0.probes" .Values.container.probes | nindent 2 }}
*/}}
{{- define "cf-common-0.24.0.probes" -}}

{{- range $probeName, $probeItem := . }}

{{- if not (or (eq "liveness" $probeName) (eq "readiness" $probeName) (eq "startup" $probeName)) }}
  {{ fail (printf "ERROR: %s is invalid probe type!" $probeName ) }}
{{- end }}

{{- if $probeItem.enabled }}
{{ $probeName }}Probe:
{{- if $probeItem.custom -}}
  {{- $probeItem.spec | toYaml | nindent 2 }}
{{- else }}
  {{- if eq $probeItem.type "httpGet" }}
  httpGet:
    path: {{ required (printf "httpGet.path is required for %s probe!" $probeName) $probeItem.httpGet.path }}
    port: {{ required (printf "httpGet.port is required for %s probe!" $probeName) $probeItem.httpGet.port }}
  {{- end }}
  {{- if eq $probeItem.type "exec" }}
  {{- if not (kindIs "slice" $probeItem.exec.command) }}
    {{ fail (printf "ERROR: exec.command block for %s probe type must be a list!" $probeName) }}
  {{- end }}
  exec:
    command: {{ toYaml $probeItem.exec.command | nindent 4 }}
  {{- end }}
  {{- if eq $probeItem.type "tcpSocket" }}
  tcpSocket:
    port: {{ required (printf "tcpSocket.port is required for %s probe!" $probeName) $probeItem.tcpSocket.port }}
  {{- end }}
  initialDelaySeconds: {{ required (printf "spec.initialDelaySeconds is required for %s probe!" $probeName) $probeItem.spec.initialDelaySeconds | int }}
  periodSeconds: {{ required (printf "spec.periodSeconds is required for %s probe!" $probeName) $probeItem.spec.periodSeconds | int }}
  timeoutSeconds: {{ required (printf "spec.timeoutSeconds is required for %s probe!" $probeName) $probeItem.spec.timeoutSeconds | int }}
  successThreshold: {{ required (printf "spec.successThreshold is required for %s probe!" $probeName) $probeItem.spec.successThreshold | int }}
  failureThreshold: {{ required (printf "spec.failureThreshold is required for %s probe!" $probeName) $probeItem.spec.failureThreshold | int }}
{{- end }}
{{- end }}

{{- end }}

{{- end }}
