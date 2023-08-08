pipeline {
    agent any
    stages {
        stage ('Invoke tekton') {
            steps {
                script {
                    echo "Helloworld!";
                    kubectl get pods;
                }
            }
        }
    }
}