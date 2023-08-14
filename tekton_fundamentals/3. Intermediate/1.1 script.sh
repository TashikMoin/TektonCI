# Installing Tasks from Tekton Hub into the Kubernetes cluster


# git-clone task
kubectl apply -f \
https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.6/git-clone.yaml

# kaniko
kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/kaniko/0.6/raw

# git
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-cli/0.4/git-cli.yaml