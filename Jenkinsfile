pipeline {
  agent {
    kubernetes {
      yamlFile 'Agent.yaml'
    }
  }
    stages {
      stage('Invoke Tekton') {     
        steps {
          container('kubectl') {
            sh '''
            kubectl get pods -n tekton-pipelines;
            kubectl get pods -n default;
            '''
          }
        } 
      }
    }
}