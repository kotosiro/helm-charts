{{/*
Expand the name of the chart.
*/}}
{{- define "sharing.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sharing.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sharing.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sharing.labels" -}}
helm.sh/chart: {{ include "sharing.chart" . }}
{{ include "sharing.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sharing.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sharing.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sharing.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sharing.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name and selector labels of sharing backend server.
*/}}
{{- define "sharing.server.name" -}}
{{ include "sharing.name" . }}-server
{{- end }}

{{- define "sharing.server.fullname" -}}
{{ include "sharing.fullname" . }}-server
{{- end -}}

{{- define "sharing.server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sharing.name" . }}-server
app.kubernetes.io/instance: {{ .Release.Name }}-server
{{- end }}

{{/*
Create the name and selector labels of sharing postgres server.
*/}}
{{- define "sharing.postgres.name" -}}
{{ include "sharing.name" . }}-postgres
{{- end }}

{{- define "sharing.postgres.fullname" -}}
{{ include "sharing.fullname" . }}-postgres
{{- end -}}

{{- define "sharing.postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sharing.name" . }}-postgres
app.kubernetes.io/instance: {{ .Release.Name }}-postgres
{{- end }}

{{- define "sharing.postgres.secretName" -}}
    {{- if .Values.global.postgres.existingSecret -}}
        {{- printf "%s" .Values.global.postgres.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "sharing.postgres.fullname" .) -}}
    {{- end -}}
{{- end -}}
