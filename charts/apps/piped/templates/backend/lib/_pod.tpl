{{- /*
The pod definition included in the controller.
*/ -}}
{{- define "backend.controller.pod" -}}
  {{- with .Values.backend.imagePullSecrets }}
imagePullSecrets:
    {{- toYaml . | nindent 2 }}
  {{- end }}
serviceAccountName: {{ include "backend.names.serviceAccountName" . }}
automountServiceAccountToken: {{ .Values.automountServiceAccountToken }}
  {{- with .Values.backend.podSecurityContext }}
securityContext:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.backend.priorityClassName }}
priorityClassName: {{ . }}
  {{- end }}
  {{- with .Values.backend.runtimeClassName }}
runtimeClassName: {{ . }}
  {{- end }}
  {{- with .Values.backend.schedulerName }}
schedulerName: {{ . }}
  {{- end }}
  {{- with .Values.backend.hostNetwork }}
hostNetwork: {{ . }}
  {{- end }}
  {{- with .Values.backend.hostname }}
hostname: {{ . }}
  {{- end }}
  {{- if .Values.backend.dnsPolicy }}
dnsPolicy: {{ .Values.backend.dnsPolicy }}
  {{- else if .Values.backend.hostNetwork }}
dnsPolicy: ClusterFirstWithHostNet
  {{- else }}
dnsPolicy: ClusterFirst
  {{- end }}
  {{- with .Values.backend.dnsConfig }}
dnsConfig:
    {{- toYaml . | nindent 2 }}
  {{- end }}
enableServiceLinks: {{ .Values.backend.enableServiceLinks }}
  {{- with .Values.termination.gracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
  {{- end }}
  {{- if .Values.backend.initContainers }}
initContainers:
    {{- $initContainers := list }}
    {{- range $index, $key := (keys .Values.backend.initContainers | uniq | sortAlpha) }}
      {{- $container := get $.Values.backend.initContainers $key }}
      {{- if not $container.name -}}
        {{- $_ := set $container "name" $key }}
      {{- end }}
      {{- if $container.env -}}
        {{- $_ := set $ "ObjectValues" (dict "env" $container.env) -}}
        {{- $newEnv := fromYaml (include "backend.controller.env_vars" $) -}}
        {{- $_ := unset $.ObjectValues "env" -}}
        {{- $_ := set $container "env" $newEnv.env }}
      {{- end }}
      {{- $initContainers = append $initContainers $container }}
    {{- end }}
    {{- tpl (toYaml $initContainers) $ | nindent 2 }}
  {{- end }}
containers:
  {{- include "backend.controller.mainContainer" . | nindent 2 }}
  {{- if .Values.backend.additionalContainers }}
    {{- $additionalContainers := list }}
    {{- range $index, $key :=  (keys .Values.backend.additionalContainers | uniq | sortAlpha) }}
    {{- $container := get $.Values.backend.additionalContainers $key }}
      {{- if not $container.name -}}
        {{- $_ := set $container "name" $key }}
      {{- end }}
      {{- if $container.env -}}
        {{- $_ := set $ "ObjectValues" (dict "env" $container.env) -}}
        {{- $newEnv := fromYaml (include "backend.controller.env_vars" $) -}}
        {{- $_ := set $container "env" $newEnv.env }}
        {{- $_ := unset $.ObjectValues "env" -}}
      {{- end }}
      {{- $additionalContainers = append $additionalContainers $container }}
    {{- end }}
    {{- tpl (toYaml $additionalContainers) $ | nindent 2 }}
  {{- end }}
  {{- with (include "backend.controller.volumes" . | trim) }}
volumes:
    {{- nindent 2 . }}
  {{- end }}
  {{- with .Values.backend.hostAliases }}
hostAliases:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.backend.nodeSelector }}
nodeSelector:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.backend.affinity }}
affinity:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.backend.topologySpreadConstraints }}
topologySpreadConstraints:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.backend.tolerations }}
tolerations:
    {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end -}}
