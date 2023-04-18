{{- /*
The pod definition included in the controller.
*/ -}}
{{- define "frontend.controller.pod" -}}
  {{- with .Values.frontend.imagePullSecrets }}
imagePullSecrets:
    {{- toYaml . | nindent 2 }}
  {{- end }}
serviceAccountName: {{ include "frontend.names.serviceAccountName" . }}
automountServiceAccountToken: {{ .Values.automountServiceAccountToken }}
  {{- with .Values.frontend.podSecurityContext }}
securityContext:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.frontend.priorityClassName }}
priorityClassName: {{ . }}
  {{- end }}
  {{- with .Values.frontend.runtimeClassName }}
runtimeClassName: {{ . }}
  {{- end }}
  {{- with .Values.frontend.schedulerName }}
schedulerName: {{ . }}
  {{- end }}
  {{- with .Values.frontend.hostNetwork }}
hostNetwork: {{ . }}
  {{- end }}
  {{- with .Values.frontend.hostname }}
hostname: {{ . }}
  {{- end }}
  {{- if .Values.frontend.dnsPolicy }}
dnsPolicy: {{ .Values.frontend.dnsPolicy }}
  {{- else if .Values.frontend.hostNetwork }}
dnsPolicy: ClusterFirstWithHostNet
  {{- else }}
dnsPolicy: ClusterFirst
  {{- end }}
  {{- with .Values.frontend.dnsConfig }}
dnsConfig:
    {{- toYaml . | nindent 2 }}
  {{- end }}
enableServiceLinks: {{ .Values.frontend.enableServiceLinks }}
  {{- with .Values.termination.gracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
  {{- end }}
  {{- if .Values.frontend.initContainers }}
initContainers:
    {{- $initContainers := list }}
    {{- range $index, $key := (keys .Values.frontend.initContainers | uniq | sortAlpha) }}
      {{- $container := get $.Values.initContainers $key }}
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
  {{- include "frontend.controller.mainContainer" . | nindent 2 }}
  {{- with .Values.additionalContainers }}
    {{- $additionalContainers := list }}
    {{- range $name, $container := . }}
      {{- if not $container.name -}}
        {{- $_ := set $container "name" $name }}
      {{- end }}
      {{- if $container.env -}}
        {{- $_ := set $ "ObjectValues" (dict "env" $container.env) -}}
        {{- $newEnv := fromYaml (include "frontend.controller.env_vars" $) -}}
        {{- $_ := set $container "env" $newEnv.env }}
        {{- $_ := unset $.ObjectValues "env" -}}
      {{- end }}
      {{- $additionalContainers = append $additionalContainers $container }}
    {{- end }}
    {{- tpl (toYaml $additionalContainers) $ | nindent 2 }}
  {{- end }}
  {{- with .Values.frontend.hostAliases }}
hostAliases:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.frontend.nodeSelector }}
nodeSelector:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.frontend.affinity }}
affinity:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.frontend.topologySpreadConstraints }}
topologySpreadConstraints:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.frontend.tolerations }}
tolerations:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.frontend.resources }}
resources:
   {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end -}}
