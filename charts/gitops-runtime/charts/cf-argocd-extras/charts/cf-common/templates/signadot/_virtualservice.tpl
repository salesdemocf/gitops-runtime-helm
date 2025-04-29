{{- define "cf-common-0.24.0.signadot.virtualservice" }}
  {{- if .Values.signadot.enabled }}

{{- $controllerName := include "cf-common-0.24.0.names.fullname" . -}}
  {{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
    {{- $controllerName = printf "%v-%v" $controllerName .Values.controller.nameOverride -}}
  {{- end -}}
{{- $containerName := include "cf-common-0.24.0.names.fullname" . -}}
  {{- if and (hasKey .Values.container "nameOverride") .Values.container.nameOverride }}
    {{- $containerName = include "cf-common-0.24.0.tplrender" (dict "Values" .Values.container.nameOverride "context" .) -}}
  {{- end }}

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: {{ include "cf-common-0.24.0.names.fullname" . }}
  labels: {{ include "cf-common-0.24.0.labels.standard" . | nindent 4 }}
spec:
  hosts:
  - {{ printf "%s.%s.svc.%s" (include "cf-common-0.24.0.names.fullname" .) .Release.Namespace .Values.global.clusterDomain }}
  http:
  - route:
    - destination:
        host: {{ include "cf-common-0.24.0.names.fullname" . }}
        port:
          number: {{ .Values.signadot.virtualservice.port  | default "80" }}
  {{- end }}
{{- end }}
