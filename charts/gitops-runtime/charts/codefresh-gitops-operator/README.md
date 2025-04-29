# codefresh-gitops-operator

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

A Helm chart for Codefresh Gitop Operator

**Homepage:** <https://codefresh.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| codefresh |  | <https://codefresh-io.github.io/> |

## Source Code

* <https://github.com/codefresh-io/codefresh-gitops-operator>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://quay.io/codefresh/charts | cf-common | 0.19.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| argoCdNotifications.argocd.repoServer.fullname | string | 'argo-cd-repo-server' | Argo CD Repo Server fullname |
| argoCdNotifications.argocd.repoServer.port | int | 8081 | Argo CD Repo Server service port |
| argoCdNotifications.argocd.url | string | `http://argo-server` | Argo CD dashboard url; used in place of {{.context.argocdUrl}} in templates |
| argoCdNotifications.cm.name | string | 'gitops-operator-notifications-cm' | The name of the config-map |
| argoCdNotifications.containerSecurityContext | object | See [values.yaml] | Notification controller container-level security Context |
| argoCdNotifications.context | object | `{}` | Define user-defined context # For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/templates/#defining-user-defined-context |
| argoCdNotifications.extraArgs | list | `[]` | Extra arguments to provide to the notifications controller |
| argoCdNotifications.extraEnv | list | `[]` | Additional container environment variables |
| argoCdNotifications.extraEnvFrom | list | `[]` (See [values.yaml]) | envFrom to pass to the notifications controller |
| argoCdNotifications.extraVolumeMounts | list | `[]` | List of extra mounts to add (normally used with extraVolumes) |
| argoCdNotifications.extraVolumes | list | `[]` | List of extra volumes to add |
| argoCdNotifications.image.imagePullPolicy | string | `IfNotPresent` (defaults to global.image.imagePullPolicy) | Image pull policy for the notifications controller |
| argoCdNotifications.image.repository | string | `quay.io/codefresh/argocd` (defaults to global.image.repository) | Repository to use for the notifications controller |
| argoCdNotifications.image.tag | string | `v2.10-2024.3.29-1dcc54e29` (defaults to global.image.tag) | Tag to use for the notifications controller |
| argoCdNotifications.imagePullSecrets | list | `[]` (defaults to global.imagePullSecrets) | Secrets with credentials to pull images from a private registry |
| argoCdNotifications.logFormat | string | `""` (defaults to global.logging.format) | Notifications controller log format. Either `text` or `json` |
| argoCdNotifications.logLevel | string | `""` (defaults to global.logging.level) | Notifications controller log level. One of: `debug`, `info`, `warn`, `error` |
| argoCdNotifications.name | string | `"notifications-controller"` | Notifications controller name string |
| argoCdNotifications.pdb.annotations | object | `{}` | Annotations to be added to notifications controller pdb |
| argoCdNotifications.pdb.enabled | bool | `false` | Deploy a [PodDisruptionBudget] for the notifications controller |
| argoCdNotifications.pdb.labels | object | `{}` | Labels to be added to notifications controller pdb |
| argoCdNotifications.pdb.maxUnavailable | string | `""` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%). # Has higher precedence over `notifications.pdb.minAvailable` |
| argoCdNotifications.pdb.minAvailable | string | `""` (defaults to 0 if not specified) | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| argoCdNotifications.resources | object | `{}` | Resource limits and requests for the notifications controller |
| argoCdNotifications.secret.name | string | `"gitops-operator-notifications-secret"` | notifications controller Secret name |
| argoCdNotifications.service.port | int | `8082` |  |
| argoCdNotifications.service.type | string | `"ClusterIP"` |  |
| command | list | `[]` |  |
| crds | object | `{"additionalLabels":{},"annotations":{},"install":true,"keep":false}` | Codefresh gitops operator crds |
| crds.additionalLabels | object | `{}` | Additional labels for gitops operator CRDs |
| crds.annotations | object | `{}` | Annotations on gitops operator CRDs |
| crds.install | bool | `true` | Whether or not to install CRDs |
| crds.keep | bool | `false` | Keep CRDs if gitops runtime release is uninstalled |
| env | object | `{}` |  |
| extraArgs | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.codefresh.tls.caCerts | object | `{"secretKeyRef":{}}` | Custom CA certificates bundle for platform access with ssl |
| global.codefresh.tls.caCerts.secretKeyRef | object | `{}` | Reference to existing secret |
| global.codefresh.url | string | `""` |  |
| global.runtime.name | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `""` |  |
| image.repository | string | `"quay.io/codefresh/codefresh-gitops-operator"` |  |
| image.tag | string | `""` | defaults to appVersion |
| imagePullSecrets | list | `[]` |  |
| libraryMode | bool | `false` | When set to true no resources will be created. This exists in order to inject values from gitops runtime chart |
| livenessProbe.failureThreshold | int | `10` |  |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `10` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| promotionTemplate.serviceAccount.annotations | object | `{}` |  |
| promotionTemplate.serviceAccount.create | bool | `true` |  |
| promotionTemplate.serviceAccount.name | string | `"promotion-template"` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `10` |  |
| replicaCount | int | `1` |  |
| resources.limits | object | `{}` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"gitops-operator-controller-manager"` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
