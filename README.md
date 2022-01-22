# Learning Kubernetes Cluster in AWS
### Init Terraform
```
terraform init
```
### Change and fill terraform.tfvars_copy with your AWS values
```
mv terraform.tfvars_copy terraform.tfvars
vim terraform.tfvars
```
### Verify terraform files
```
terraform plan
```
### Apply Terraform
```
terraform apply
```
### Go to master node and check cp.out file
```
sudo kubeadm join --token 118c3e.83b49999dc5dc034 \
10.128.0.3:6443 --discovery-token-ca-cert-hash \
sha256:40aa946e3f53e38271bae24723866f56c86d77efb49aedeb8a70cc189bfe2e1d
```
Copy and paste to worker nodes
### Verify the cluster
```
ubuntu@ip-172-31-71-88:~$ kubectl get node
NAME               STATUS   ROLES                  AGE   VERSION
cp                 Ready    control-plane,master   89m   v1.21.1
ip-172-31-21-46    Ready    <none>                 55m   v1.21.1
ip-172-31-33-101   Ready    <none>                 55m   v1.21.1
```
### Notes
The original version with `k8scp.sh` and `k8sSecond.sh` use podman as container
container engine.
https://podman.io/

If you want to use docker container engine, please change the `main.tf`
```
sed -i 's/k8scp.sh/k8scp-docker.sh/g' main.tf
sed -i 's/k8sSecond.sh/k8sSecond-docker.sh/g' main.tf
sed -i 's/kubeadm.yaml/kubeadm-docker.yaml/g' main.tf
```
