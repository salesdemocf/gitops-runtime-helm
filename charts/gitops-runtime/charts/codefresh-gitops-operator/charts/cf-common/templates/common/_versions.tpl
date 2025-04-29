{{/*
Return the target Kubernetes version
*/}}
{{- define "cf-common-0.19.2.kubeVersion" -}}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for HPA
*/}}
{{- define "cf-common-0.19.2.apiVersion.autoscaling" -}}
{{- if .Values.apiVersionOverrides -}}
  {{- if .Values.apiVersionOverrides.autoscaling -}}
    {{- print .Values.apiVersionOverrides.autoscaling -}}
  {{- else -}}
    {{- print "autoscaling/v2" -}}
  {{- end -}}
{{- else if semverCompare "<1.23-0" (include "cf-common-0.19.2.kubeVersion" . ) -}}
  {{- print "autoscaling/v2beta2" -}}
{{- else -}}
  {{- print "autoscaling/v2" -}}
{{- end -}}
{{- end -}}
