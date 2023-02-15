{{- /* The main container included in the controller */ -}}
{{- define "ytproxy.controller.mainContainer" -}}
- name: {{ include "ytproxy.names.fullname" . }}
  image: {{ printf "%s:%s" .Values.ytproxy.image.repository (default .Chart.AppVersion .Values.ytproxy.image.tag) | quote }}
  imagePullPolicy: {{ .Values.ytproxy.image.pullPolicy }}
  {{- with .Values.ytproxy.command }}
  command:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
      {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.ytproxy.args }}
  args:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.ytproxy.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.lifecycle }}
  lifecycle:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.termination.messagePath }}
  terminationMessagePath: {{ . }}
  {{- end }}
  {{- with .Values.termination.messagePolicy }}
  terminationMessagePolicy: {{ . }}
  {{- end }}

  {{- with .Values.ytproxy.env }}
  env:
    {{- get (fromYaml (include "ytproxy.controller.env_vars" $)) "env" | toYaml | nindent 4 -}}
  {{- end }}
  {{- if or .Values.ytproxy.envFrom .Values.ytproxy.secret }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- if .Values.secret }}
    - secretRef:
        name: {{ include "ytproxy.names.fullname" . }}
    {{- end }}
  {{- end }}
  {{- include "ytproxy.controller.probes" . | trim | nindent 2 }}
  ports:
  {{- include "ytproxy.controller.ports" . | trim | nindent 4 }}
{{- end -}}