# piped

![Version: 6.0.0](https://img.shields.io/badge/Version-6.0.0-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

Piped is an alternative privacy-friendly YouTube frontend which is efficient by design.

## Source Code

* <https://github.com/TeamPiped/Piped>
* <https://github.com/TeamPiped/Piped-Backend>
* <https://github.com/TeamPiped/piped-proxy>

## Requirements

Kubernetes: `>=1.22.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://bjw-s.github.io/helm-charts | common | 1.5.1 |
| https://charts.bitnami.com/bitnami | postgresql | 15.5.11 |

## Installing the Chart

```bash
# Add the repository
helm repo add TeamPiped https://helm.piped.video

# Install the chart
helm install TeamPiped piped -f values.yaml
```

## Values

The following table contains an overview of available values and their descriptions / default values.

<details>
<summary>Expand</summary>

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backend.config.HTTP_WORKERS | int | `2` |  |
| backend.config.PORT | int | `8080` |  |
| backend.enabled | bool | `true` |  |
| backend.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| backend.image.repository | string | `"1337kavin/piped"` | image repository |
| backend.image.tag | string | `nil` | image tag @chart.appVersion |
| backend.service.main.enabled | bool | `true` |  |
| backend.service.main.ports.http.enabled | bool | `true` |  |
| backend.service.main.ports.http.port | int | `8080` |  |
| backend.service.main.ports.http.primary | bool | `true` |  |
| backend.service.main.ports.http.protocol | string | `"HTTP"` |  |
| backend.service.main.primary | bool | `true` |  |
| backend.service.main.type | string | `"ClusterIP"` |  |
| controller.enabled | bool | `false` | enable the controller. |
| frontend.args[0] | string | `"-c"` |  |
| frontend.args[1] | string | `"sed -i s/pipedapi.kavin.rocks/$BACKEND_HOSTNAME/g /usr/share/nginx/html/assets/* && /docker-entrypoint.sh nginx -g 'daemon off;'"` |  |
| frontend.command | string | `"/bin/ash"` |  |
| frontend.enabled | bool | `true` |  |
| frontend.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| frontend.image.repository | string | `"1337kavin/piped-frontend"` | image repository |
| frontend.image.tag | string | `nil` | image tag @chart.appVersion |
| frontend.service.main.enabled | bool | `true` |  |
| frontend.service.main.ports.http.enabled | bool | `true` |  |
| frontend.service.main.ports.http.port | int | `80` |  |
| frontend.service.main.ports.http.primary | bool | `true` |  |
| frontend.service.main.ports.http.protocol | string | `"HTTP"` |  |
| frontend.service.main.primary | bool | `true` |  |
| frontend.service.main.type | string | `"ClusterIP"` |  |
| global.annotations | object | `{}` | Set additional global annotations. Helm templates can be used. |
| global.fullnameOverride | string | `nil` | Set the entire name definition |
| global.labels | object | `{}` | Set additional global labels. Helm templates can be used. |
| global.nameOverride | string | `nil` | Set an override for the prefix of the fullname |
| ingress.backend.enabled | bool | `true` |  |
| ingress.backend.hosts[0].host | string | `"pipedapi.piped.video"` |  |
| ingress.backend.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.backend.ingressClassName | string | `"nginx"` |  |
| ingress.backend.primary | bool | `false` |  |
| ingress.backend.tls | list | `[]` |  |
| ingress.main.enabled | bool | `true` |  |
| ingress.main.hosts[0].host | string | `"piped.video"` |  |
| ingress.main.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.main.primary | bool | `true` |  |
| ingress.main.tls | list | `[]` |  |
| ingress.ytproxy.enabled | bool | `true` |  |
| ingress.ytproxy.hosts[0].host | string | `"ytproxy.piped.video"` |  |
| ingress.ytproxy.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.ytproxy.ingressClassName | string | `"nginx"` |  |
| ingress.ytproxy.primary | bool | `false` |  |
| ingress.ytproxy.tls | list | `[]` |  |
| postgresql.auth.database | string | `"piped"` |  |
| postgresql.auth.password | string | `"changemepiped"` |  |
| postgresql.auth.username | string | `"piped"` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.image.tag | string | `"13.12.0-debian-11-r58"` |  |
| probes | object | See below | [[ref]](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| probes.liveness | object | See below | Liveness probe configuration |
| probes.liveness.custom | bool | `false` | Set this to `true` if you wish to specify your own livenessProbe |
| probes.liveness.enabled | bool | `true` | Enable the liveness probe |
| probes.liveness.spec | object | See below | The spec field contains the values for the default livenessProbe. If you selected `custom: true`, this field holds the definition of the livenessProbe. |
| probes.readiness | object | See below | Redainess probe configuration |
| probes.readiness.custom | bool | `false` | Set this to `true` if you wish to specify your own readinessProbe |
| probes.readiness.enabled | bool | `true` | Enable the readiness probe |
| probes.readiness.spec | object | See below | The spec field contains the values for the default readinessProbe. If you selected `custom: true`, this field holds the definition of the readinessProbe. |
| probes.startup | object | See below | Startup probe configuration |
| probes.startup.custom | bool | `false` | Set this to `true` if you wish to specify your own startupProbe |
| probes.startup.enabled | bool | `true` | Enable the startup probe |
| probes.startup.spec | object | See below | The spec field contains the values for the default startupProbe. If you selected `custom: true`, this field holds the definition of the startupProbe. |
| serviceAccount.create | bool | `false` |  |
| termination.gracePeriodSeconds | string | `nil` |  |
| ytproxy.command | string | `"/app/piped-proxy"` |  |
| ytproxy.enabled | bool | `true` |  |
| ytproxy.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| ytproxy.image.repository | string | `"1337kavin/piped-proxy"` | image repository |
| ytproxy.image.tag | string | `nil` | image tag @chart.appVersion |
| ytproxy.service.main.enabled | bool | `true` |  |
| ytproxy.service.main.ports.http.enabled | bool | `true` |  |
| ytproxy.service.main.ports.http.port | int | `8080` |  |
| ytproxy.service.main.ports.http.primary | bool | `true` |  |
| ytproxy.service.main.ports.http.protocol | string | `"HTTP"` |  |
| ytproxy.service.main.primary | bool | `true` |  |
| ytproxy.service.main.type | string | `"ClusterIP"` |  |

</details>

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)