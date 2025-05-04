# metric-app-assignment

helm uninstall metrics-app -n metrics   
helm install metrics-app ./metrics-app --namespace metrics --create-namespace