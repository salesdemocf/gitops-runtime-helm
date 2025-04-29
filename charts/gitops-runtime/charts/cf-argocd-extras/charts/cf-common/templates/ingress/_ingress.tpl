{{/*
Iterates over Ingress objects and calls render template.
Must be called from chart root context.
{{- include "cf-common-0.24.0.ingress" . -}}
*/}}
{{- define "cf-common-0.24.0.ingress" -}}
  {{- $primary := "" -}}
  {{- range $name, $ingress := .Values.ingress -}}
    {{- if and (hasKey $ingress "primary") $ingress.primary $ingress.enabled -}}
      {{- $primary = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $primary -}}
    {{- $primary = keys .Values.ingress | first -}}
  {{- end -}}

  {{- range $name, $ingress := .Values.ingress -}}
    {{- if $ingress.enabled -}}
      {{- $ingressValues := $ingress -}}

      {{/* set defaults */}}
      {{- if and (not $ingressValues.nameOverride) (ne $name $primary) -}}
        {{- $_ := set $ingressValues "nameOverride" $name -}}
      {{- end -}}

      {{- $_ := set $ingressValues "name" $name -}}
      {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
      {{- include "cf-common-0.24.0.ingress.render" $ | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Renders Ingress objects.
Called from the template above.
*/}}
{{- define "cf-common-0.24.0.ingress.render" -}}
  {{- $fullName := include "cf-common-0.24.0.names.fullname" . -}}
  {{- $ingressName := $fullName -}}
  {{- $ingressItem := .Values.ingress -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.ingress -}}
      {{- $ingressItem = . -}}
    {{- end -}}
  {{- end -}}

  {{- if and (hasKey $ingressItem "nameOverride") $ingressItem.nameOverride -}}
    {{- $ingressName = printf "%v-%v" $ingressName $ingressItem.nameOverride -}}
  {{- end -}}

  {{- $defaultServiceName := $fullName -}}
  {{- $defaultServicePort := dict -}}
  {{- if .Values.service -}}
    {{- $primaryService := get .Values.service (include "cf-common-0.24.0.service.primary" (dict "values" .Values.service)) -}}
    {{- $defaultServicePort = get $primaryService.ports (include "cf-common-0.24.0.service.primaryPort" (dict "values" $primaryService)) -}}
  {{- end -}}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $ingressName }}
  labels: {{ include "cf-common-0.24.0.labels.standard" $ | nindent 4 }}
  {{- if $ingressItem.labels }}
  {{- include "cf-common-0.24.0.tplrender" (dict "Values" $ingressItem.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if $ingressItem.annotations }}
  annotations: {{- include "cf-common-0.24.0.tplrender" (dict "Values" $ingressItem.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  {{- if $ingressItem.ingressClassName }}
  ingressClassName: {{ include "cf-common-0.24.0.tplrender" (dict "Values" $ingressItem.ingressClassName "context" $) }}
  {{- end }}
  {{- if $ingressItem.tls }}
  tls:
    {{- if not (kindIs "slice" $ingressItem.tls) }}
      {{- fail (printf "ERROR: ingress.%s.tls must be a list!" $ingressItem.name) }}
    {{- end }}
    {{- range $ingressItem.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ include "cf-common-0.24.0.tplrender" (dict "Values" . "context" $) | quote }}
        {{- end }}
      {{- if .secretName }}
      secretName: {{ include "cf-common-0.24.0.tplrender" (dict "Values" .secretName "context" $) | quote}}
      {{- end }}
    {{- end }}
  {{- end }}
  rules:
    {{- if not (kindIs "slice" $ingressItem.hosts) }}
      {{- fail (printf "ERROR: ingress.%s.hosts must be a list!" $ingressItem.name) }}
    {{- end }}
  {{- range $ingressItem.hosts }}
    - host: {{ include "cf-common-0.24.0.tplrender" (dict "Values" .host "context" $) | quote }}
      http:
        paths:
          {{- if not (kindIs "slice" .paths) }}
            {{- fail (printf "ERROR: ingress.%s.hosts[].paths must be a list!" $ingressItem.name ) }}
          {{- end }}
          {{- range .paths }}
            {{- $service := $defaultServiceName -}}
            {{- $port := $defaultServicePort.port -}}
            {{- if .service -}}
              {{- $service = default $service .service.name -}}
              {{- $port = default $port .service.port -}}
            {{- end }}
          - path: {{ include "cf-common-0.24.0.tplrender" (dict "Values" .path "context" $) | quote }}
            pathType: {{ default "ImplementationSpecific" .pathType }}
            backend:
              service:
                name: {{ include "cf-common-0.24.0.tplrender" (dict "Values" $service "context" $) }}
                port:
                  number: {{ include "cf-common-0.24.0.tplrender" (dict "Values" $port "context" $) }}
          {{- end }}
  {{- end }}
{{- end -}}
