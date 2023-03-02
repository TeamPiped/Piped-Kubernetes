# piped

![Version: 0.0.3](https://img.shields.io/badge/Version-0.0.3-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

Piped is an alternative privacy-friendly YouTube frontend which is efficient by design.

**Homepage:** <https://github.com/TeamPiped/Piped-Kubernetes>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Skyler Mäntysaari | samip5@users.noreply.github.com |  |

## Source Code

* <https://github.com/TeamPiped/Piped>
* <https://github.com/TeamPiped/Piped-Backend>
* <https://github.com/TeamPiped/piped-proxy>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://bjw-s.github.io/helm-charts | common | 0.1.0 |
| https://charts.bitnami.com/bitnami | postgresql | 12.2.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backend.args[0] | string | `"-server"` |  |
| backend.args[10] | string | `"-Xtune:virtualized"` |  |
| backend.args[11] | string | `"-jar"` |  |
| backend.args[12] | string | `"/app/piped.jar"` |  |
| backend.args[1] | string | `"-Xmx1G"` |  |
| backend.args[2] | string | `"-Xaggressive"` |  |
| backend.args[3] | string | `"-XX:+UnlockExperimentalVMOptions"` |  |
| backend.args[4] | string | `"-XX:+OptimizeStringConcat"` |  |
| backend.args[5] | string | `"-XX:+UseStringDeduplication"` |  |
| backend.args[6] | string | `"-XX:+UseCompressedOops"` |  |
| backend.args[7] | string | `"-XX:+UseNUMA"` |  |
| backend.args[8] | string | `"-Xgcpolicy:gencon"` |  |
| backend.args[9] | string | `"-Xshareclasses:allowClasspaths"` |  |
| backend.command | string | `"/opt/java/openjdk/bin/java"` |  |
| backend.enabled | bool | `true` |  |
| backend.image | object | `{"pullPolicy":"IfNotPresent","repository":"1337kavin/piped","tag":null}` |  Outgoing HTTP Proxy - eg: 127.0.0.1:8118 Captcha Parameters Enable haveibeenpwned compromised password API Disable Registration Feed Retention Time in Days  connection_url: jdbc:postgresql://postgres:5432/piped  driver_class: org.postgresql.Driver  dialect: org.hibernate.dialect.PostgreSQLDialect  username: piped  password: changeme |
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
| frontend.args[1] | string | `"sed -i s/pipedapi.kavin.rocks/$BACKEND_HOSTNAME/g /usr/share/nginx/html/assets/* && /docker-entrypoint.sh && nginx -g 'daemon off;'"` |  |
| frontend.command | string | `"/bin/ash"` |   BACKEND_HOSTNAME: pipedapi.example.org |
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
| ingress.main.primary | bool | `false` |  |
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
| postgresql.image.tag | string | `"11.19.0-debian-11-r4"` |  |
| probes | object | See below | Probe configuration -- [[ref]](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| probes.liveness | object | See below | Liveness probe configuration |
| probes.liveness.custom | bool | `false` | Set this to `true` if you wish to specify your own livenessProbe |
| probes.liveness.enabled | bool | `false` | Enable the liveness probe |
| probes.liveness.spec | object | See below | The spec field contains the values for the default livenessProbe. If you selected `custom: true`, this field holds the definition of the livenessProbe. |
| probes.readiness | object | See below | Redainess probe configuration |
| probes.readiness.custom | bool | `false` | Set this to `true` if you wish to specify your own readinessProbe |
| probes.readiness.enabled | bool | `false` | Enable the readiness probe |
| probes.readiness.spec | object | See below | The spec field contains the values for the default readinessProbe. If you selected `custom: true`, this field holds the definition of the readinessProbe. |
| probes.startup | object | See below | Startup probe configuration |
| probes.startup.custom | bool | `false` | Set this to `true` if you wish to specify your own startupProbe |
| probes.startup.enabled | bool | `false` | Enable the startup probe |
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

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v0.1.1](https://github.com/k8s-at-home/helm-docs/releases/v0.1.1)
