{{/*
Renders the ingress objects required.
*/}}
{{- define "ytproxy.classes.ingress" -}}
  {{- /* Generate named services as required */ -}}
  {{- range $name, $service := .Values.ytproxy.service }}
    {{- if $service.enabled -}}
      {{- $serviceValues := $service -}}

      {{/* set the default nameOverride to the service name */}}
      {{- if and (not $serviceValues.nameOverride) (ne $name (include "ytproxy.service.primary" $)) -}}
        {{- $_ := set $serviceValues "nameOverride" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "service" $serviceValues) -}}
      {{- include "ytproxy.classes.service" $ }}
    {{- end }}
  {{- end }}
{{- end }}