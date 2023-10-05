{{/*
Expand the name of the chart.
*/}}
{{- define "tarantool.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tarantool.fullname" -}}
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
{{- define "tarantool.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tarantool.labels" -}}
helm.sh/chart: {{ include "tarantool.chart" . }}
{{ include "tarantool.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tarantool.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tarantool.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tarantool.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tarantool.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get tarantool files directory
*/}}
{{- define "tarantool.FilesDir" -}}
{{- printf "/etc/tarantool-src" -}}
{{- end }}

{{/*
Get tarantool config file directory
*/}}
{{- define "tarantool.configFileDir" -}}
{{- printf "%s/config" (include "tarantool.FilesDir" .) -}}
{{- end }}

{{/*
Get tarantool config file name
*/}}
{{- define "tarantool.configFileName" -}}
{{- printf "tarantool.tmpl" -}}
{{- end }}

{{/*
Get tarantool config file path
*/}}
{{- define "tarantool.configFilePath" -}}
{{- printf "%s/%s" (include "tarantool.configFileDir" .) (include "tarantool.configFileName" .) -}}
{{- end }}

{{/*
Get tarantool settings directory path
*/}}
{{- define "tarantool.settingsDir" -}}
{{- printf "%s/settings" (include "tarantool.FilesDir" .) -}}
{{- end }}

{{/*
Get tarantool partials directory path
*/}}
{{- define "tarantool.partialsDir" -}}
{{- printf "%s/partials" (include "tarantool.FilesDir" .) -}}
{{- end }}

{{/*
Get tarantool templates directory path
*/}}
{{- define "tarantool.templatesDir" -}}
{{- printf "%s/templates" (include "tarantool.FilesDir" .) -}}
{{- end }}
