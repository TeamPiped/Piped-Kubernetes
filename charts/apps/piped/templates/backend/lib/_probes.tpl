{{/*
Probes selection logic.
*/}}
{{- define "backend.controller.probes" -}}
{{- $primaryService := get .Values.backend.service (include "backend.service.primary" .) -}}
{{- $primaryPort := "" -}}
{{- if $primaryService -}}
  {{- $primaryPort = get $primaryService.ports (include "backend.classes.service.ports.primary" (dict "serviceName" (include "backend.service.primary" .) "values" $primaryService)) -}}
{{- end -}}

{{- range $probeName, $probe := .Values.probes }}
  {{- if $probe.enabled -}}
    {{- "" | nindent 0 }}
    {{- $probeName }}Probe:
    {{- if $probe.custom -}}
      {{- $probe.spec | toYaml | nindent 2 }}
    {{- else }}
      {{- if and $primaryService $primaryPort -}}
        {{- "tcpSocket:" | nindent 2 }}
          {{- if $primaryPort.targetPort }}
            {{- printf "port: %v" $primaryPort.targetPort | nindent 4 }}
          {{- else}}
            {{- printf "port: %v" $primaryPort.port | nindent 4 }}
          {{- end }}
        {{- printf "initialDelaySeconds: %v" $probe.spec.initialDelaySeconds  | nindent 2 }}
        {{- printf "failureThreshold: %v" $probe.spec.failureThreshold  | nindent 2 }}
        {{- printf "timeoutSeconds: %v" $probe.spec.timeoutSeconds  | nindent 2 }}
        {{- printf "periodSeconds: %v" $probe.spec.periodSeconds | nindent 2 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}