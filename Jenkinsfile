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
            sed -i "s/<COMMIT>/${BUILD_NUMBER}/" pipelinerun_from_jenkins.yaml
            sed -i "s/<TAG>/${BUILD_NUMBER}/" pipelinerun_from_jenkins.yaml
            kubectl apply -f pipelinerun_from_jenkins.yaml
            kubectl logs -f -l tekton.dev/pipeline=build-test-deploy-pipeline --all-containers
            '''
          }
        } 
      }
    }
}
