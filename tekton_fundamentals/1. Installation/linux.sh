# dashboard
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml

kubectl apply --filename dashboard-permissions.yaml

# pipeline 
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# triggers
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml

# chains
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/chains/latest/release.yaml


# configure Tekton Chains to store the provenance metadata locally
kubectl patch configmap chains-config -n tekton-chains \
-p='{"data":{"artifacts.oci.storage": "", "artifacts.taskrun.format":"in-toto", "artifacts.taskrun.storage": "tekton"}}'

# kaniko
kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/kaniko/0.6/raw

# tkn cli
sudo apt update;sudo apt install -y gnupg
sudo mkdir -p /etc/apt/keyrings/
sudo mkdir -p /root/.gnupg
sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/tektoncd.gpg --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA
echo "deb [signed-by=/etc/apt/keyrings/tektoncd.gpg] http://ppa.launchpad.net/tektoncd/cli/ubuntu eoan main"|sudo tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list
sudo apt update && sudo apt install -y tektoncd-cli
