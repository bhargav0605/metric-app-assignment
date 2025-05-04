
# 📄 Deployment Report – `metrics-app` via Argo CD & Helm

## 🧾 Overview

| Field            | Value                                         |
|------------------|-----------------------------------------------|
| Application Name | `metrics-app`                                 |
| Deployment Tool  | Helm and ArgoCD                             |
| Cluster          | Kind (`kind-argocd`)                          |
| Environment      | Local Development                             |
| Git Repo         | [github.com/bhargav0605/metric-app-assignment](https://github.com/bhargav0605/metric-app-assignment) |
| Chart Path       | `helm-charts/metrics-app`                     |
<!-- | Observability    | NGINX Ingress, Prometheus, OpenTelemetry (partial) | -->

## 🚀 Deployment Steps

1. **Run `./environment-setup/setup-kind-argocd.sh`**:

    This script includes below steps:
    - Create kind cluster with `kind-config.yaml` file.
    - Install `ArgoCD` from github script.
    - Install `Ingress-NGINX` for ingress.
    - Create ArgoCD application using `metrics-app-argo.yaml` for Metric App deployment using helm-chart.
   
5. **Access the App**:
    - Open: [http://localhost/counter](http://localhost/counter)
    - Open: [ArgoCD](http://localhost:8080)

## ⚠️ Issues Encountered

| Issue Description                               
|--------------------------------------------------         
| Flask app raised `ValueError: empty range`       


## 🔍 Diagnosis & Fixes

### 🐛 Issue: Flask Exception on `/counter`

**Error Log:**
```
ValueError: empty range in randrange(180, 31)
```

**Diagnosis:**  
`random.randint(180, 30)` used — invalid as 180 > 30.

**Fix:**  
Changed to `random.randint(30, 180)`

**Reference:**
[Python Document](https://docs.python.org/3/library/random.html#random.randint)


## 🔍 Root Cause Analysis (Summary)

| Issue                                  | Root Cause                                  | Fix                                       |
|----------------------------------------|---------------------------------------------|--------------------------------------------|
| App crash on `/counter`                | Incorrect `randint` range                   | random.randint(30, 180)                         |

## 📸 Screenshots / Logs

<table>
<tr>
    <td><img src="./screenshots/Screenshot 2025-05-04 at 16.29.31.png" width="250"/>
    <p>Success</p></td>
    <td><img src="./screenshots/Screenshot 2025-05-04 at 16.29.40.png" width="250"/>
    <p>Failure</p></td>
    <td><img src="./screenshots/Screenshot 2025-05-04 at 16.30.16.png" width="250"/>
    <p>Pod Logs</p></td>
</tr>
<tr>
    <td><img src="./screenshots/Screenshot 2025-05-04 at 18.13.07.png" width="250"/>
    <p>ArgoCD Dashboard</p></td>
</tr>
</table>

## ✅ Conclusion

The `metrics-app` Helm chart was successfully deployed using Argo CD with full GitOps integration. Minor issues were diagnosed, logged. Ingress routing paths are working correctly. Ready for further telemetry enhancements via OpenTelemetry.
