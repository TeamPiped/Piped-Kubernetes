{{- /*
The pod definition included in the controller.
*/ -}}
{{- define "ytproxy.controller.pod" -}}
  {{- with .Values.ytproxy.imagePullSecrets }}
imagePullSecrets:
    {{- toYaml . | nindent 2 }}
  {{- end }}
serviceAccountName: {{ include "ytproxy.names.serviceAccountName" . }}
automountServiceAccountToken: {{ .Values.automountServiceAccountToken }}
  {{- with .Values.ytproxy.podSecurityContext }}
securityContext:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.ytproxy.priorityClassName }}
priorityClassName: {{ . }}
  {{- end }}
  {{- with .Values.ytproxy.runtimeClassName }}
runtimeClassName: {{ . }}
  {{- end }}
  {{- with .Values.ytproxy.schedulerName }}
schedulerName: {{ . }}
  {{- end }}
  {{- with .Values.ytproxy.hostNetwork }}
hostNetwork: {{ . }}
  {{- end }}
  {{- with .Values.ytproxy.hostname }}
hostname: {{ . }}
  {{- end }}
  {{- if .Values.ytproxy.dnsPolicy }}
dnsPolicy: {{ .Values.ytproxy.dnsPolicy }}
  {{- else if .Values.ytproxy.hostNetwork }}
dnsPolicy: ClusterFirstWithHostNet
  {{- else }}
dnsPolicy: ClusterFirst
  {{- end }}
  {{- with .Values.ytproxy.dnsConfig }}
dnsConfig:
    {{- toYaml . | nindent 2 }}
  {{- end }}
enableServiceLinks: {{ .Values.ytproxy.enableServiceLinks }}
  {{- with .Values.termination.gracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
  {{- end }}
  {{- if .Values.ytproxy.initContainers }}
initContainers:
    {{- $initContainers := list }}
    {{- range $index, $key := (keys .Values.ytproxy.initContainers | uniq | sortAlpha) }}
      {{- $container := get $.Values.ytproxy.initContainers $key }}
      {{- if not $container.name -}}
        {{- $_ := set $container "name" $key }}
      {{- end }}
      {{- if $container.env -}}
        {{- $_ := set $ "ObjectValues" (dict "env" $container.env) -}}
        {{- $newEnv := fromYaml (include "common.controller.env_vars" $) -}}
        {{- $_ := unset $.ObjectValues "env" -}}
        {{- $_ := set $container "env" $newEnv.env }}
      {{- end }}
      {{- $initContainers = append $initContainers $container }}
    {{- end }}
    {{- tpl (toYaml $initContainers) $ | nindent 2 }}
  {{- end }}
containers:
  {{- include "ytproxy.controller.mainContainer" . | nindent 2 }}
  {{- if .Values.ytproxy.additionalContainers }}
    {{- $additionalContainers := list }}
    {{- range $index, $key :=  (keys .Values.ytproxy.additionalContainers | uniq | sortAlpha) }}
    {{- $container := get $.Values.ytproxy.additionalContainers $key }}
      {{- if not $container.name -}}
        {{- $_ := set $container "name" $key }}
      {{- end }}
      {{- if $container.env -}}
        {{- $_ := set $ "ObjectValues" (dict "env" $container.env) -}}
        {{- $newEnv := fromYaml (include "ytproxy.controller.env_vars" $) -}}
        {{- $_ := set $container "env" $newEnv.env }}
        {{- $_ := unset $.ObjectValues "env" -}}
      {{- end }}
      {{- $additionalContainers = append $additionalContainers $container }}
    {{- end }}
    {{- tpl (toYaml $additionalContainers) $ | nindent 2 }}
  {{- end }}
  {{- with (include "ytproxy.controller.volumes" . | trim) }}
volumes:
    {{- nindent 2 . }}
  {{- end }}
  {{- with .Values.ytproxy.hostAliases }}
hostAliases:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.ytproxy.nodeSelector }}
nodeSelector:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.ytproxy.affinity }}
affinity:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.ytproxy.topologySpreadConstraints }}
topologySpreadConstraints:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.ytproxy.tolerations }}
tolerations:
    {{- toYaml . | nindent 2 }}
  {{- end -}}
{{- end -}}
