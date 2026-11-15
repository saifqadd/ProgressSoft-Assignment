# Kubernetes sample

## Status

Verified on 2026-11-15 using the official K3s v1.37.2+k3s1 image in a privileged Docker Desktop/WSL2 container. The node reported `Ready`; the Nginx deployment reached 1/1 available; its ClusterIP service returned HTTP 200 through a localhost-only port-forward. The cluster state is stored in a named Docker volume. Oracle was stopped during this cluster test to keep heavy workloads sequential; its database volume was preserved.

`nginx.yaml` defines a one-replica Nginx Deployment with readiness/liveness probes and a ClusterIP Service. It is a sample deployment for the assignment, not a production exposure setup. The approved local demonstration uses the official K3s container image inside Docker Desktop/WSL2 so no separate guest OS packages or existing VirtualBox configuration need to change.

## K3s single-node learning cluster in Docker Desktop

`k3s-compose.yaml` pins the official K3s image to `v1.37.2-k3s1`, runs a single privileged server container with a 3 GiB memory limit, binds the API and test port only to Windows localhost, and persists cluster state in a named volume. K3s requires the privileged container mode for its node components; this is a local development cluster, not production hardening. The K3s project documents running its official image in Docker and using a valid explicit version tag: [K3s: Running K3s in Docker](https://docs.k3s.io/advanced#running-k3s-in-docker).

The node log contains cgroup warnings from the nested WSL2 environment; despite those warnings, the node became `Ready`, and the deployment, readiness probe, service, and HTTP checks all passed. The initial readiness probe used `k3s kubectl`, which did not work through this image's command aliases; using the image's `/bin/kubectl` alias corrected it.

From the repository root in PowerShell:

```powershell
docker compose -f kubernetes/k3s-compose.yaml up -d
docker compose -f kubernetes/k3s-compose.yaml ps
docker exec kubernetes-k3s-server-1 kubectl get nodes -o wide
Get-Content -Raw kubernetes/nginx.yaml | docker exec -i kubernetes-k3s-server-1 kubectl apply -f -
docker exec kubernetes-k3s-server-1 kubectl rollout status deployment/assignment-nginx --timeout=180s
docker exec kubernetes-k3s-server-1 kubectl get nodes,pods,deployments,services -o wide
docker exec -d kubernetes-k3s-server-1 kubectl port-forward --address 0.0.0.0 service/assignment-nginx 8081:80
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:8081/
```

Stop the cluster while preserving its named volume:

```bash
docker compose -f kubernetes/k3s-compose.yaml stop
```

Do not use `docker compose ... down -v`; it deletes the cluster-state volume. To remove only the sample resources, use `docker exec kubernetes-k3s-server-1 kubectl delete -f -` with the manifest. The Ubuntu guest path remains an alternative if the assignment specifically requires installation inside that VM; it needs a running guest and sudo authentication.
