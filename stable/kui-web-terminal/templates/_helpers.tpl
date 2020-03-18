{{/*
Return arch based on kube platform
*/}}
{{/* 
Remove old way of determining platform architecture as Helm v3.0.x removed .Capabilities.KubeVersion.Platform. 
See https://github.com/helm/helm/issues/7004 for details.  Until it is added back, for now we will hardcode
to assume "amd64".
*/}}
{{- define "kui-proxy.arch" -}}
  {{- printf "%s" "amd64" }}
{{- end -}}