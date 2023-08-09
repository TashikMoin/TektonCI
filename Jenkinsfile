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
            script {
                def logs = sh(script: '''
                    sed -i "s/<COMMIT>/${BUILD_NUMBER}/" pipelinerun_from_jenkins.yaml
                    sed -i "s/<TAG>/${BUILD_NUMBER}/" pipelinerun_from_jenkins.yaml
                    kubectl apply -f pipelinerun_from_jenkins.yaml
                    sleep 20
                    kubectl logs -f -l tekton.dev/pipelineRun=build-test-deploy-pipeline-pipelinerun-${BUILD_NUMBER} --all-containers | tee kubectl_logs.txt
                ''', returnStdout: true).trim()
                echo "PIPELINE LOGS \n${logs}\n"
                def kubectlLogs = readFile('kubectl_logs.txt')
                echo "\n${kubectlLogs}"
            }
          }
        } 
      }
    }
}
