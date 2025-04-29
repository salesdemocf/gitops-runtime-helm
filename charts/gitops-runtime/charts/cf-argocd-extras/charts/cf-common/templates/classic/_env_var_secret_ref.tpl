{{- /*
MONGODB_HOST env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.mongodb-host-env-var-secret-name" }}
  {{- if or .Values.mongodbHostSecretKeyRef .Values.global.mongodbHostSecretKeyRef }}
{{- printf (coalesce .Values.mongodbHostSecretKeyRef.name .Values.global.mongodbHostSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_HOST env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.mongodb-host-env-var-secret-key" }}
  {{- if or .Values.mongodbHostSecretKeyRef .Values.global.mongodbHostSecretKeyRef }}
{{- printf (coalesce .Values.mongodbHostSecretKeyRef.key .Values.global.mongodbHostSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "MONGODB_HOST" }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_USER env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.mongodb-user-env-var-secret-name" }}
  {{- if or .Values.mongodbUserSecretKeyRef .Values.global.mongodbUserSecretKeyRef }}
{{- printf (coalesce .Values.mongodbUserSecretKeyRef.name .Values.global.mongodbUserSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_USER env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.mongodb-user-env-var-secret-key" }}
  {{- if or .Values.mongodbUserSecretKeyRef .Values.global.mongodbUserSecretKeyRef }}
{{- printf (coalesce .Values.mongodbUserSecretKeyRef.key .Values.global.mongodbUserSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "MONGODB_USER" }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_PASSWORD env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.mongodb-password-env-var-secret-name" }}
  {{- if or .Values.mongodbPasswordSecretKeyRef .Values.global.mongodbPasswordSecretKeyRef }}
{{- printf (coalesce .Values.mongodbPasswordSecretKeyRef.name .Values.global.mongodbPasswordSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_PASSWORD env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.mongodb-password-env-var-secret-key" }}
  {{- if or .Values.mongodbPasswordSecretKeyRef .Values.global.mongodbPasswordSecretKeyRef }}
{{- printf (coalesce .Values.mongodbPasswordSecretKeyRef.key .Values.global.mongodbPasswordSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "MONGODB_PASSWORD" }}
  {{- end }}
{{- end }}

{{- /*
MONGO_URI env var value
*/}}
{{- define "cf-common-0.24.0.classic.mongo-uri-env-var-value" }}
{{- /*
Check for legacy global.mongoURI
*/}}
  {{- if .Values.global.mongoURI }}
{{- print "$(MONGO_URI)" }}
{{- /*
New secret implementation
*/}}
  {{- else }}
{{- print "$(MONGODB_PROTOCOL)://$(MONGODB_USER):$(MONGODB_PASSWORD)@$(MONGODB_HOST)/$(MONGODB_DATABASE)?$(MONGODB_OPTIONS)" }}
  {{- end }}
{{- end }}

{{- /*
MONGO_URI_ARCHIVE env var value
*/}}
{{- define "cf-common-0.24.0.classic.mongo-uri-archive-env-var-value" }}
{{- /*
Check for legacy global.mongoURIArchive or global.mongoURI
*/}}
  {{- if or .Values.global.mongoURIArchive .Values.global.mongoURI }}
{{- print "$(MONGO_URI_ARCHIVE)" }}
{{- /*
New secret implementation
*/}}
  {{- else }}
{{- print "$(MONGODB_PROTOCOL)://$(MONGODB_USER):$(MONGODB_PASSWORD)@$(MONGODB_HOST)/$(MONGODB_DATABASE_ARCHIVE)?$(MONGODB_OPTIONS)" }}
  {{- end }}
{{- end }}


{{- /*
REDIS_URL env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.redis-url-env-var-secret-name" }}
  {{- if or .Values.redisUrlSecretKeyRef .Values.global.redisUrlSecretKeyRef }}
{{- printf (coalesce .Values.redisUrlSecretKeyRef.name .Values.global.redisUrlSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
REDIS_URL env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.redis-url-env-var-secret-key" }}
  {{- if or .Values.redisUrlSecretKeyRef .Values.global.redisUrlSecretKeyRef }}
{{- printf (coalesce .Values.redisUrlSecretKeyRef.key .Values.global.redisUrlSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "REDIS_URL" }}
  {{- end }}
{{- end }}

{{- /*
REDIS_PASSWORD env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.redis-password-env-var-secret-name" }}
  {{- if or .Values.redisPasswordSecretKeyRef .Values.global.redisPasswordSecretKeyRef }}
{{- printf (coalesce .Values.redisPasswordSecretKeyRef.name .Values.global.redisPasswordSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
REDIS_PASSWORD env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.redis-password-env-var-secret-key" }}
  {{- if or .Values.redisPasswordSecretKeyRef .Values.global.redisPasswordSecretKeyRef }}
{{- printf (coalesce .Values.redisPasswordSecretKeyRef.key .Values.global.redisPasswordSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "REDIS_PASSWORD" }}
  {{- end }}
{{- end }}

{{- /*
POSTGRES_HOSTNAME env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.postgres-hostname-env-var-secret-name" }}
  {{- if or .Values.postgresHostnameSecretKeyRef .Values.global.postgresHostnameSecretKeyRef }}
{{- printf (coalesce .Values.postgresHostnameSecretKeyRef.name .Values.global.postgresHostnameSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
POSTGRES_HOSTNAME env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.postgres-hostname-env-var-secret-key" }}
  {{- if or .Values.postgresHostnameSecretKeyRef .Values.global.postgresHostnameSecretKeyRef }}
{{- printf (coalesce .Values.postgresHostnameSecretKeyRef.key .Values.global.postgresHostnameSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "POSTGRES_HOSTNAME" }}
  {{- end }}
{{- end }}

{{- /*
POSTGRES_PASSWORD env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.postgres-password-env-var-secret-name" }}
  {{- if or .Values.postgresPasswordSecretKeyRef .Values.global.postgresPasswordSecretKeyRef }}
{{- printf (coalesce .Values.postgresPasswordSecretKeyRef.name .Values.global.postgresPasswordSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
POSTGRES_PASSWORD env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.postgres-password-env-var-secret-key" }}
  {{- if or .Values.postgresPasswordSecretKeyRef .Values.global.postgresPasswordSecretKeyRef }}
{{- printf (coalesce .Values.postgresPasswordSecretKeyRef.key .Values.global.postgresPasswordSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "POSTGRES_PASSWORD" }}
  {{- end }}
{{- end }}

{{- /*
POSTGRES_USER env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.postgres-user-env-var-secret-name" }}
  {{- if or .Values.postgresUserSecretKeyRef .Values.global.postgresUserSecretKeyRef }}
{{- printf (coalesce .Values.postgresUserSecretKeyRef.name .Values.global.postgresUserSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
POSTGRES_USER env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.postgres-user-env-var-secret-key" }}
  {{- if or .Values.postgresUserSecretKeyRef .Values.global.postgresUserSecretKeyRef }}
{{- printf (coalesce .Values.postgresUserSecretKeyRef.key .Values.global.postgresUserSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "POSTGRES_USER" }}
  {{- end }}
{{- end }}

{{- /*
RABBITMQ_HOSTNAME env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.rabbitmq-hostname-env-var-secret-name" }}
  {{- if or .Values.rabbitmqHostnameSecretKeyRef .Values.global.rabbitmqHostnameSecretKeyRef }}
{{- printf (coalesce .Values.rabbitmqHostnameSecretKeyRef.name .Values.global.rabbitmqHostnameSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
RABBITMQ_HOSTNAME env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.rabbitmq-hostname-env-var-secret-key" }}
  {{- if or .Values.rabbitmqHostnameSecretKeyRef .Values.global.rabbitmqHostnameSecretKeyRef }}
{{- printf (coalesce .Values.rabbitmqHostnameSecretKeyRef.key .Values.global.rabbitmqHostnameSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "RABBITMQ_HOSTNAME" }}
  {{- end }}
{{- end }}

{{- /*
RABBITMQ_PASSWORD env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.rabbitmq-password-env-var-secret-name" }}
  {{- if or .Values.rabbitmqPasswordSecretKeyRef .Values.global.rabbitmqPasswordSecretKeyRef }}
{{- printf (coalesce .Values.rabbitmqPasswordSecretKeyRef.name .Values.global.rabbitmqPasswordSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
RABBITMQ_PASSWORD env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.rabbitmq-password-env-var-secret-key" }}
  {{- if or .Values.rabbitmqPasswordSecretKeyRef .Values.global.rabbitmqPasswordSecretKeyRef }}
{{- printf (coalesce .Values.rabbitmqPasswordSecretKeyRef.key .Values.global.rabbitmqPasswordSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "RABBITMQ_PASSWORD" }}
  {{- end }}
{{- end }}

{{- /*
RABBITMQ_USERNAME env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.rabbitmq-username-env-var-secret-name" }}
  {{- if or .Values.rabbitmqUsernameSecretKeyRef .Values.global.rabbitmqUsernameSecretKeyRef }}
{{- printf (coalesce .Values.rabbitmqUsernameSecretKeyRef.name .Values.global.rabbitmqUsernameSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
RABBITMQ_USERNAME env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.rabbitmq-username-env-var-secret-key" }}
  {{- if or .Values.rabbitmqUsernameSecretKeyRef .Values.global.rabbitmqUsernameSecretKeyRef }}
{{- printf (coalesce .Values.rabbitmqUsernameSecretKeyRef.key .Values.global.rabbitmqUsernameSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "RABBITMQ_USERNAME" }}
  {{- end }}
{{- end }}

{{- /*
FIREBASE_SECRET env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.firebase-secret-env-var-secret-name" }}
  {{- if or .Values.firebaseSecretSecretKeyRef .Values.global.firebaseSecretSecretKeyRef }}
{{- printf (coalesce .Values.firebaseSecretSecretKeyRef.name .Values.global.firebaseSecretSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
FIREBASE_SECRET env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.firebase-secret-env-var-secret-key" }}
  {{- if or .Values.firebaseSecretSecretKeyRef .Values.global.firebaseSecretSecretKeyRef }}
{{- printf (coalesce .Values.firebaseSecretSecretKeyRef.key .Values.global.firebaseSecretSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "FIREBASE_SECRET" }}
  {{- end }}
{{- end }}

{{- /*
FIREBASE_URL env var secret name
*/}}
{{- define "cf-common-0.24.0.classic.firebase-url-env-var-secret-name" }}
  {{- if or .Values.firebaseUrlSecretKeyRef .Values.global.firebaseUrlSecretKeyRef }}
{{- printf (coalesce .Values.firebaseUrlSecretKeyRef.name .Values.global.firebaseUrlSecretKeyRef.name) }}
  {{- else }}
{{- printf "%s-%s" (include "cf-common-0.24.0.names.fullname" .) "secret" }}
  {{- end }}
{{- end }}

{{- /*
FIREBASE_URL env var secret key
*/}}
{{- define "cf-common-0.24.0.classic.firebase-url-env-var-secret-key" }}
  {{- if or .Values.firebaseUrlSecretKeyRef .Values.global.firebaseUrlSecretKeyRef }}
{{- printf (coalesce .Values.firebaseUrlSecretKeyRef.key .Values.global.firebaseUrlSecretKeyRef.key) }}
  {{- else }}
{{- printf "%s" "FIREBASE_URL" }}
  {{- end }}
{{- end }}
