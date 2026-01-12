{{- /* The main container included in the controller */ -}}
{{ define "backend.controller.mainContainer" -}}
- name: {{ include "backend.names.fullname" . }}
  image: {{ printf "%s:%s" .Values.backend.image.repository (default .Chart.AppVersion .Values.backend.image.tag) | quote }}
  {{- if Values.global.image.pullPolicy }}
  imagePullPolicy: {{ .Values.global.image.pullPolicy | default .Values.backend.image.pullPolicy }}
  {{- end }}
  {{- with .Values.backend.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.backend.command }}
  command:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
      {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.backend.args }}
  args:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.backend.securityContext }}
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

  {{- with .Values.backend.env }}
  env:
    {{- get (fromYaml (include "backend.controller.env_vars" $)) "env" | toYaml | nindent 4 -}}
  {{- end }}
  {{- if or .Values.backend.envFrom .Values.backend.secret }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- if .Values.secret }}
    - secretRef:
        name: {{ include "backend.names.fullname" . }}
    {{- end }}
  {{- end }}
  ports:
  {{- include "backend.controller.ports" . | trim | nindent 4 }}
  {{- with (include "backend.controller.volumeMounts" . | trim) }}
  volumeMounts:
    {{- nindent 4 . }}
  {{- end }}
  {{- include "backend.controller.probes" . | trim | nindent 2 }}
{{- end -}}