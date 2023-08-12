pipeline {
  agent {
    kubernetes {
      yamlFile 'Agent.yaml'
    }
  }
    stages {
      stage('Invoke tekton pipeline using kubectl') {     
        steps {
          container('kubectl') {
            script {
              sh '''
                sed -i "s/<COMMIT>/${BUILD_NUMBER}/" pipelinerun_from_jenkins.yaml
                sed -i "s/<TAG>/${BUILD_NUMBER}/" pipelinerun_from_jenkins.yaml
                kubectl apply -f pipelinerun_from_jenkins.yaml
                kubectl logs -f -l tekton.dev/pipelineRun=build-test-deploy-pipeline-pipelinerun-${BUILD_NUMBER} --all-containers
              '''
            }
          }
        } 
      }
      stage('Invoke tekton pipeline using curl') {     
        steps {
          container('curl') {
            script {
              sh '''
                curl http://nginx.default.svc.cluster.local
              '''
            }
          }
        } 
      }
    }
}
