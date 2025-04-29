{{- define "cf-common-0.19.2.controller.analysis-template" -}}

{{- $fullName:= include "cf-common-0.19.2.names.fullname" . }}

---
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: error-rate-{{ $fullName }}
spec:
  {{- with .Values.controller.rollout.analysisTemplate }}
  args: {{- include "cf-common-0.19.2.tplrender" (dict "Values" .args "context" $) | nindent 4 }}
  metrics: {{- .metrics | toYaml | nindent 4 }}
  {{- end }}

{{- end }}
