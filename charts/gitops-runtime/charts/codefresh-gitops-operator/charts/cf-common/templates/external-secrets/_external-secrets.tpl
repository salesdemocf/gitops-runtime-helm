{{- define "cf-common-0.19.2.external-secrets" }}
  {{- range $i, $secret := .Values.externalSecrets }}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ $secret.name }}
  {{- with $secret.labels }}
  labels: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- with $secret.annotations }}
  annotations: {{ toYaml . | nindent 4 }}
  {{- end }}
spec:
  refreshInterval: {{ $secret.refreshInterval | default "1m" }}
    {{- if hasKey . "secretStoreRef" }}
  secretStoreRef:
    name: {{ .secretStoreRef.name }}
    kind: {{ .secretStoreRef.kind | default "ClusterSecretStore" }}
    {{- else }}
  secretStoreRef:
    name: asm
    kind: ClusterSecretStore
    {{- end }}
  target:
    name: {{ .name }}
    creationPolicy: {{ .creationPolicy | default "Owner" }}
    deletionPolicy: {{ .deletionPolicy | default "Retain" }}
  data:
    {{- range $i, $key := $secret.keys }}
  - secretKey: {{ $key.name }}
    remoteRef:
        {{- if hasKey $key "remoteSecretName"}}
      key: {{ $key.remoteSecretName }}
        {{- else }}
      key: {{ $secret.remoteSecretName }}
        {{- end }}
      property: {{ $key.remoteKey }}
      {{- with $key.decodingStrategy }}
      decodingStrategy: {{ . }}
      {{- end -}}
    {{- end }}
  dataFrom:
    {{- range $i, $key := $secret.keysFrom }}
  - extract:
      key: {{ $key.remoteSecretName | default $secret.remoteSecretName }}
      {{- with $key.decodingStrategy }}
      decodingStrategy: {{ . }}
      {{- end }}
    {{- end }}
---
  {{- end }}
{{- end }}
