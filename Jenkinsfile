pipeline {
  agent any
    stages {
      stage('Invoke Tekton') {     
        steps {
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
