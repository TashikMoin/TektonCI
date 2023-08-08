# Installing a Task from Tekton Hub
# To use the git clone Task inside our pipeline, we have to install it on our cluster first. we can do this with the following command:

kubectl apply -f \
https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.6/git-clone.yaml