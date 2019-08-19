## Create an istio-enabled GKE cluster

```bash
cd infra
terraform init
terraform apply
```

```bash
gcloud container clusters get-credentials --region <REGION> <CLUSTER>
kubectl label namespace default istio-injection=enabled
```

## Install mesh policy and ingress policy

```bash
kubectl apply -n istio-system -f authn/
```

## Install OPA adapter resources

```bash
kubectl apply -f opa-mixer/
```

## Install demo resources

```bash
kubectl apply -f httpbin/
```
