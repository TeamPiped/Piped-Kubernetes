{{- /* The main container included in the controller */ -}}
{{- define "frontend.controller.mainContainer" -}}
- name: {{ include "frontend.names.fullname" . }}
  image: {{ printf "%s:%s" .Values.frontend.image.repository (default .Chart.AppVersion .Values.frontend.image.tag) | quote }}
  imagePullPolicy: {{ .Values.frontend.image.pullPolicy }}
  {{- with .Values.frontend.command }}
  command:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
      {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.frontend.args }}
  args:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.frontend.securityContext }}
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

  {{- with .Values.frontend.env }}
  env:
    {{- get (fromYaml (include "frontend.controller.env_vars" $)) "env" | toYaml | nindent 4 -}}
  {{- end }}
  {{- if or .Values.frontend.envFrom .Values.frontend.secret }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- if .Values.secret }}
    - secretRef:
        name: {{ include "frontend.names.fullname" . }}
    {{- end }}
  {{- end }}
  {{- include "frontend.controller.probes" . | trim | nindent 2 }}
  ports:
  {{- include "frontend.controller.ports" . | trim | nindent 4 }}
{{- end -}}