# cf-common

Codefresh library chart

![Version: 0.24.0](https://img.shields.io/badge/Version-0.24.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square) ![AppVersion: v0.0.0](https://img.shields.io/badge/AppVersion-v0.0.0-informational?style=flat-square)

## Installing the Chart

This is a [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm).

**WARNING: THIS CHART IS NOT MEANT TO BE INSTALLED DIRECTLY**

## Using this library

Include this chart as a dependency in your `Chart.yaml` e.g.

```yaml
# Chart.yaml
dependencies:
- name: cf-common
  version: 0.24.0
  repository: https://chartmuseum.codefresh.io/cf-common
```

**Read through the [values.yaml](./values.yaml) file.**

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalContainers | list | `[]` | Array of extra (sidecar) containers to add |
| affinity | object | `{}` | Set affinity constrains |
| apiVersionOverrides | object | `{"autoscaling":""}` | Override APIVersions |
| apiVersionOverrides.autoscaling | string | `""` | String to override apiVersion of autoscaling ONLY `autoscaling/v2` or `autoscaling/v2beta2` |
| automountServiceAccountToken | bool | `true` | Specifies whether a service account token should be automatically mounted. |
| configMaps | object | See below | Create configMap with the values you provide. Additional configMaps can be added by adding a dictionary key similar to the 'config' object. |
| configMaps.config | object | `{"annotations":{},"data":{},"enabled":false,"labels":{}}` | ConfigMap name. Make sure to use the same name in `volumes` and `container.volumeMounts` |
| configMaps.config.annotations | object | `{}` | Add additional annotations to the configMap |
| configMaps.config.data | object | `{}` | ConfigMap data content. |
| configMaps.config.enabled | bool | `false` | Enable the configMap |
| configMaps.config.labels | object | `{}` | Add additional labels to the configMap |
| container | object | See below | Main Container parameters |
| container.args | list | `[]` | Override args for the container |
| container.command | list | `[]` | Override commands for the container |
| container.containerSecurityContext | object | `{}` | Set security context for container |
| container.env | object | `{}` | Set environments variables. Helm template supported. |
| container.envFrom | list | `[]` | Set Secrets or ConfigMaps loaded as environment variables. |
| container.extraEnv | object | `{}` | Append extra environment variables to the container |
| container.image | object | `{"digest":null,"pullPolicy":null,"registry":null,"repository":null,"tag":null}` | Image parameters |
| container.image.digest | string | `nil` | Set image digest |
| container.image.pullPolicy | string | `nil` | Set image pull policy (`Always`, `Never`, `IfNotPresent`) |
| container.image.registry | string | `nil` | Set image registry |
| container.image.repository | string | `nil` | Set image repository |
| container.image.tag | string | `nil` | Set image tag |
| container.lifecycle | object | `{}` | Set the lifecycle hooks for container |
| container.nameOverride | string | `""` | Set the container name |
| container.probes.liveness.enabled | bool | `false` | Enable liveness probe |
| container.probes.liveness.exec.command | list | `[]` | Set exec probe commands |
| container.probes.liveness.httpGet.path | string | `nil` | Set httpGet probe path |
| container.probes.liveness.httpGet.port | string | `nil` | Set httpGet probe port (name ) |
| container.probes.liveness.spec.failureThreshold | string | `nil` | Set failure threshold for probe |
| container.probes.liveness.spec.initialDelaySeconds | string | `nil` | Set initial delay seconds for probe |
| container.probes.liveness.spec.periodSeconds | string | `nil` | Set period seconds for probe |
| container.probes.liveness.spec.successThreshold | string | `nil` | Set success threshold for probe |
| container.probes.liveness.spec.timeoutSeconds | string | `nil` | Set timeout seconds for probe |
| container.probes.liveness.type | string | `nil` | Set liveness probe type (httpGet/exec) |
| container.resources | object | `{"limits":{},"requests":{}}` | Set the resources (requests/limits) for the container |
| container.volumeMounts | object | `{}` | Set volume mounts for container |
| controller | object | See below | Controller parameters |
| controller.annotations | object | `{}` | Set annotations on controller |
| controller.cronjob.concurrencyPolicy | string | `"Forbid"` | Specifies how to treat concurrent executions of a job that is created by this cron job, valid values are Allow, Forbid or Replace |
| controller.cronjob.failedJobsHistory | int | `1` | The number of failed Jobs to keep |
| controller.cronjob.schedule | string | `"*/20 * * * *"` | Sets the CronJob time when to execute your jobs |
| controller.cronjob.startingDeadlineSeconds | int | `30` | The deadline in seconds for starting the job if it misses its scheduled time for any reason |
| controller.cronjob.successfulJobsHistory | int | `1` | The number of succesful Jobs to keep |
| controller.cronjob.suspend | string | `nil` | This flag tells the controller to suspend subsequent executions, it does not apply to already started executions. Defaults to false. |
| controller.cronjob.ttlSecondsAfterFinished | string | `nil` | If this field is set, ttlSecondsAfterFinished after the Job finishes, it is eligible to be automatically deleted. |
| controller.job.activeDeadlineSeconds | string | `nil` | Set the duration in seconds relative to the startTime that the job may be continuously active before the system tries to terminate it; value must be positive integer. (int) |
| controller.job.backoffLimit | string | `nil` | Set the number of retries before marking this job failed. Defaults to 6. (int) |
| controller.job.completions | string | `nil` | Set the desired number of successfully finished pods the job should be run with. (int) |
| controller.job.manualSelector | string | `nil` | Controls generation of pod labels and pod selectors. Leave manualSelector unset unless you are certain what you are doing. (boolean) Ref: https://kubernetes.io/docs/concepts/workloads/controllers/job/#specifying-your-own-pod-selector |
| controller.job.parallelism | string | `nil` | Set the maximum desired number of pods the job should run at any given time. (int) |
| controller.job.selector | string | `nil` | A label query over pods that should match the pod count. Normally, the system sets this field for you. Ref: https://kubernetes.io/docs/concepts/workloads/controllers/job/#specifying-your-own-pod-selector |
| controller.job.suspend | string | `nil` | Suspend specifies whether the Job controller should create Pods or not. (boolean) |
| controller.job.ttlSecondsAfterFinished | string | `nil` | Set the limit on the lifetime of a Job that has finished execution (either Complete or Failed). (int) |
| controller.labels | object | `{}` | Set labels on controller |
| controller.nameOverride | string | `""` | Override the name suffix that is used for this controller |
| controller.podManagementPolicy | string | `nil` | Set statefulset podManagementPolicy (`OrderedReady`(default)/`Parallel`). |
| controller.replicas | string | `nil` | Set number of pods |
| controller.revisionHistoryLimit | string | `nil` | Set ReplicaSet revision history limit |
| controller.rollingUpdate | object | `{"maxSurge":null,"maxUnavailable":null,"partition":null}` | RollingUpdate strategy parameters |
| controller.rollingUpdate.maxSurge | Deployment | `nil` | Set RollingUpdate max surge (absolute number or percentage) |
| controller.rollingUpdate.maxUnavailable | Deployment | `nil` | Set RollingUpdate max unavailable (absolute number or percentage) |
| controller.rollingUpdate.partition | StatefulSet | `nil` | Set RollingUpdate partition |
| controller.rollout.analysis.successfulRunHistoryLimit | string | `nil` | Limits the number of successful analysis runs and experiments to be stored in a history |
| controller.rollout.analysis.unsuccessfulRunHistoryLimit | string | `nil` | Limits the number of unsuccessful analysis runs and experiments to be stored in a history. ( Stages for unsuccessful: "Error", "Failed", "Inconclusive" ) |
| controller.rollout.canary | object | `{"maxSurge":null,"maxUnavailable":null,"steps":[{"setWeight":null},{"pause":{"duration":null}},{"setWeight":null},{"pause":{"duration":null}}]}` | Canary update strategy parameters |
| controller.rollout.canary.maxSurge | string | `nil` | The maximum number of pods that can be scheduled above the original number of pods. Value can be an absolute number / percentage |
| controller.rollout.canary.maxUnavailable | string | `nil` | The maximum number of pods that can be unavailable during the update. Value can be an absolute number / percentage |
| controller.rollout.canary.steps | list | `[{"setWeight":null},{"pause":{"duration":null}},{"setWeight":null},{"pause":{"duration":null}}]` | Steps define sequence of steps to take during an update of the canary. |
| controller.rollout.canary.steps[0] | object | `{"setWeight":null}` | Sets the ratio of canary ReplicaSet in percentage. |
| controller.rollout.canary.steps[1] | object | `{"pause":{"duration":null}}` | Pauses the rollout for configured duration of time. Supported units: s, m, h. when setting `duration: {}` it will pauses indefinitely until manually resumed |
| controller.rollout.strategy | string | `nil` | Rollout update strategy - can be Canary or BlueGreen. |
| controller.strategy | string | `nil` | Set controller upgrade strategy For Deployment: `RollingUpdate`(default) / `Recreate` For StatefulSet: `RollingUpdate`(default) / `OnDelete` For Rollout: `Canary(default) / `BlueGreen` |
| controller.type | string | `""` | Define the controller type (`deployment`/`rollout`/`job`/`cronjob`) |
| externalSecrets | list | `[]` | Create External Secrets |
| extraResources | list | `[]` | Array of extra objects to deploy with the release |
| fullNameOverride | string | `""` | String to fully override app name |
| global | object | `{"affinity":{},"clusterDomain":"","controller":{},"env":{},"imagePullSecrets":[],"imageRegistry":"","nodeSelector":{},"tolerations":[]}` | Global parameters |
| global.affinity | object | `{}` | Set global affinity constrains |
| global.clusterDomain | string | `""` | Cluster domain |
| global.env | object | `{}` | Global Env vars. NO precedence over `.Values.container.env` |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as array |
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.nodeSelector | object | `{}` | Set global node selection constrains |
| global.tolerations | list | `[]` | Set global tolerations constrains |
| hpa | object | See below | Configure autoscaling (Horizontal Pod Autoscaler) |
| hpa.enabled | bool | `false` | Enable HPA |
| hpa.maxReplicas | string | `nil` | Set maximum autoscaling replicas |
| hpa.metrics | list | `[]` | Set custom metrics |
| hpa.minReplicas | string | `nil` | Set minimum autoscaling replicas |
| hpa.targetCPUUtilizationPercentage | string | `nil` | Set target CPU utilization percentage |
| hpa.targetMemoryUtilizationPercentage | string | `nil` | Set target memory utilization percentage |
| imagePullSecrets | list | `[]` | Set image pull secrets as array |
| ingress | object | See below | Configure the Ingresses for the chart. Additional Ingresses can be added by adding a dictionary key similar to the 'main' ingress. |
| ingress.main.annotations | object | `{}` | Add additional annotations for ingress. |
| ingress.main.enabled | bool | `false` | Enables or disables the ingress |
| ingress.main.hosts[0].host | string | `"domain.example.com"` | Host address. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].path | string | `"/"` | Path. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].pathType | string | `nil` | Path Type (`Prefix`/`ImplementationSpecific`(default)/`Exact`) |
| ingress.main.hosts[0].paths[0].service.name | string | `nil` | Overrides the service name reference for this path. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].service.port | string | `nil` | Overrides the service port reference for this path. Helm template can be passed. |
| ingress.main.ingressClassName | string | `nil` | Set the ingressClass that is used for the ingress. |
| ingress.main.labels | object | `{}` | Add additional labels for ingress. |
| ingress.main.tls | list | `[]` | Configure TLS for the ingress. Both secretName and hosts can process a Helm template. |
| initContainers | object | `{}` | Map of init containers to add Follows the same values structure as in `.Values.containes` The map key (e.g. `sleep`) will be used for the container name. |
| keda | object | `{"auth":{"enabled":false,"secretTargetRef":[]},"enabled":false,"spec":{"advanced":{},"annotations":{},"cooldownPeriod":null,"envSourceContainerName":null,"fallback":{},"idleReplicaCount":null,"maxReplicaCount":null,"minReplicaCount":null,"pollingInterval":null,"scaleTargetRef":{},"triggers":[]}}` | Configure KEDA Autoscaling |
| keda.auth | object | `{"enabled":false,"secretTargetRef":[]}` | TriggerAuthentication parameters Ref: https://keda.sh/docs/2.14/concepts/authentication/ |
| keda.auth.secretTargetRef | list | `[]` | Set secret target reference |
| keda.enabled | bool | `false` | Enable ScaledObject |
| keda.spec | object | `{"advanced":{},"annotations":{},"cooldownPeriod":null,"envSourceContainerName":null,"fallback":{},"idleReplicaCount":null,"maxReplicaCount":null,"minReplicaCount":null,"pollingInterval":null,"scaleTargetRef":{},"triggers":[]}` | ScaledObject parameters Ref: https://keda.sh/docs/2.14/concepts/scaling-deployments/ |
| keda.spec.envSourceContainerName | string | `nil` | Override envSourceContainerName |
| keda.spec.scaleTargetRef | object | `{}` | Override scaleTargetRef |
| keda.spec.triggers | list | `[]` | Configure Scalers Ref: https://keda.sh/docs/2.14/scalers/ |
| kubeVersionOverride | string | `""` | Override the Kubernetes version |
| nameOverride | string | `""` | Provide a name in place of chart name |
| nodeSelector | object | `{}` | Set node selection constrains |
| pdb.enabled | bool | `false` | Enable PDB |
| pdb.maxUnavailable | string | `""` | Set number of pods that are unavailable after eviction as number of percentage |
| pdb.minAvailable | string | `""` | Set number of pods that are available after eviction as number of percentage |
| persistence | object | See below | Configure persistence for the chart Additional items can be added by adding a dictionary key similar to the 'data' key. |
| persistence.data | object | `{"accessMode":"ReadWriteOnce","enabled":false,"nameOverride":null,"retain":false,"size":"1Gi","storageClass":null}` | PersistentVolumeClaim name. |
| persistence.data.accessMode | string | `"ReadWriteOnce"` | (required) Set AccessMode for persistent volume |
| persistence.data.enabled | bool | `false` | Enable the PVC |
| persistence.data.nameOverride | string | `nil` | Override the PVC name |
| persistence.data.retain | bool | `false` | Set to true to retain the PVC upon `helm uninstall` |
| persistence.data.size | string | `"1Gi"` | (required) Set the requested size for persistent volume |
| persistence.data.storageClass | string | `nil` | Set Storage Class for PVC object If set to `-`, dynamic provisioning is disabled. If set to something else, the given storageClass is used. If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner. |
| podAnnotations | object | `{}` | Set additional pod annotations |
| podLabels | object | `{}` | Set additional pod labels |
| podMonitor | object | See below | Configure PodMonitors for the chart. Additional podMonitors can be added by adding a dictionary key similar to the 'main' service monitor. |
| podMonitor.main | object | `{"annotations":{},"enabled":false,"fullNameOverride":"","labels":{},"nameOverride":"","namespaceSelector":{},"podMetricsEndpoints":[{"path":"/metrics","targetPort":9100}],"selector":{}}` | pod monitor name |
| podMonitor.main.annotations | object | `{}` | Add additional annotations for the pod monitor |
| podMonitor.main.enabled | bool | `false` | Enable pod monitor |
| podMonitor.main.fullNameOverride | string | `""` | Override pod monitor full name |
| podMonitor.main.labels | object | `{}` | Add additional labels for the pod monitor |
| podMonitor.main.nameOverride | string | `""` | Override pod monitor name suffix |
| podMonitor.main.namespaceSelector | object | `{}` | Set namespace selector. If nil, release namespace is used. |
| podMonitor.main.podMetricsEndpoints | list | `[{"path":"/metrics","targetPort":9100}]` | Set endpoints for pod monitor |
| podMonitor.main.selector | object | `{}` | Override the default selector for the podMonitor. Takes precedence over default labels. Helm template can be used. |
| podSecurityContext | object | `{}` | Set security context for the pod |
| rbac | object | See below | Configure RBAC parameters |
| rbac.enabled | bool | `false` | Enable RBAC resources |
| rbac.namespaced | bool | `true` | Restrict RBAC in a single namespace instead of cluster-wide scope |
| rbac.rules | list | `[]` | Create custom rules |
| secrets.secret | object | `{"annotation":{},"data":{},"enabled":false,"labels":{},"stringData":{},"type":"Opaque"}` | Secret name. Make sure to use the same name in `volumes` and `container.volumeMounts` |
| secrets.secret.annotation | object | `{}` | Add additional annotations to the secret |
| secrets.secret.enabled | bool | `false` | Enable the secret |
| secrets.secret.labels | object | `{}` | Add additional labels to the secret |
| secrets.secret.stringData | object | `{}` | Secret data content. Plain text (not base64). Helm template supported. Passed through `tpl`, should be configured as string |
| secrets.secret.type | string | `"Opaque"` | Set secret type (`Opaque`/`kubernetes.io/tls`) |
| service | object | See below | Configure services fo the chart. Additional services can be added by adding a dictionary key similar to the 'main' service. |
| service.main | object | `{"annotations":{},"enabled":false,"extraSelectorLabels":{},"labels":{},"ports":{"http":{"port":null,"protocol":"HTTP","targetPort":null}},"primary":true,"type":"ClusterIP"}` | Service name |
| service.main.annotations | object | `{}` | Add additional annotations for the service |
| service.main.enabled | bool | `false` | Enabled the service |
| service.main.extraSelectorLabels | object | `{}` | Allow adding additional match labels |
| service.main.labels | object | `{}` | Add additional labels for the service |
| service.main.ports | object | `{"http":{"port":null,"protocol":"HTTP","targetPort":null}}` | Configure ports for the service |
| service.main.ports.http | object | `{"port":null,"protocol":"HTTP","targetPort":null}` | Port name |
| service.main.ports.http.port | string | `nil` | Port number |
| service.main.ports.http.protocol | string | `"HTTP"` | Port protocol (`HTTP`/`HTTPS`/`TCP`/`UDP`) |
| service.main.ports.http.targetPort | string | `nil` | Set a service targetPort if you wish to differ the service port from the application port. |
| service.main.primary | bool | `true` | Make this the primary service (used in probes, notes, etc...). If there is more than 1 service, make sure that only 1 service is marked as primary. |
| service.main.type | string | `"ClusterIP"` | Set the service type |
| serviceAccount | object | See below | Configure Service Account |
| serviceAccount.annotations | object | `{}` | Set annotations for Service Account |
| serviceAccount.enabled | bool | `false` | Enable and create Service Account |
| serviceAccount.nameOverride | string | `""` | Override Service Account name (by default, name is generated with `fullname` template) |
| serviceAccount.secret | object | `{"enabled":false}` | Secret for Service Account |
| serviceAccount.secret.enabled | bool | `false` | Create secret for Service Account |
| serviceMonitor | object | See below | Configure ServiceMonitors for the chart. Additional ServiceMonitors can be added by adding a dictionary key similar to the 'main' service monitor. |
| serviceMonitor.main | object | `{"annotations":{},"enabled":false,"endpoints":[{"interval":"1m","path":"/metrics","port":"http","scheme":"http","scrapeTimeout":"10s"}],"fullNameOverride":"","labels":{},"nameOverride":"","namespaceSelector":{},"selector":{}}` | Service monitor name |
| serviceMonitor.main.annotations | object | `{}` | Add additional annotations for the service monitor |
| serviceMonitor.main.enabled | bool | `false` | Enable service monitor |
| serviceMonitor.main.endpoints | list | `[{"interval":"1m","path":"/metrics","port":"http","scheme":"http","scrapeTimeout":"10s"}]` | Set endpoints for service monitor |
| serviceMonitor.main.fullNameOverride | string | `""` | Override service monitor full name |
| serviceMonitor.main.labels | object | `{}` | Add additional labels for the service monitor |
| serviceMonitor.main.nameOverride | string | `""` | Override service monitor name suffix |
| serviceMonitor.main.namespaceSelector | object | `{}` | Set namespace selector. If nil, release namespace is used. |
| serviceMonitor.main.selector | object | `{}` | Override the default selector for the serviceMonitor. Takes precedence over default labels. Helm template can be used. |
| signadot | object | See below | Configure Pod Disruption Budget |
| terminationGracePeriodSeconds | string | `nil` | Duration in seconds the pod needs to terminate gracefully |
| tolerations | list | `[]` | Set tolerations constrains |
| topologySpreadConstraints | list | `[]` | Set topologySpreadConstraints rules. Helm template supported. Passed through `tpl`, should be configured as string |
| volumeClaimTemplates | object | `{}` | Used with `controller.type: statefulset` to create individual disks for each instance. |
| volumes | object | See below | Configure volume for the controller. Additional items can be added by adding a dictionary key similar to the 'config'/`secret` key. |
| volumes.config | object | `{"enabled":false,"type":"configMap"}` | Volume name. Make sure to use the same name in `configMaps`/`secrets`/`persistence` and `container.volumeMounts` |
| volumes.config.enabled | bool | `false` | Enable the volume |
| volumes.config.type | string | `"configMap"` | Volume type (configMap/secret/pvc/emptyDir) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.9.1](https://github.com/norwoodj/helm-docs/releases/v1.9.1)