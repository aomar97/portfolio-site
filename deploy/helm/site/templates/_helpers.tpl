{{- define "site.name" -}}portfolio-site{{- end -}}

{{- define "site.selectorLabels" -}}
app.kubernetes.io/name: {{ include "site.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "site.labels" -}}
{{ include "site.selectorLabels" . }}
app.kubernetes.io/part-of: portfolio
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "site.image" -}}
{{- if .Values.image.registry }}{{ .Values.image.registry }}/{{ end }}{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}
