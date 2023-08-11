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
                    kubectl logs -f -l tekton.dev/pipelineRun=build-test-deploy-pipeline-pipelinerun-${BUILD_NUMBER} --all-containers
                ''', returnStdout: true).trim()
                echo "PIPELINE LOGS \n${logs}\n"
            }
          }
        }
      }
      stage ('Logging') {
          steps {
              script {
                  def output = sh(script: "cat /etc/os-release", returnStdout: true)
                  echo "Output: ${output}"
                  sh """
                      #!/bin/bash
                      apt-get update
                      apt-get install -y ca-certificates curl
                      apt-get install -y apt-transport-https
                      curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
                      echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
                      apt-get update
                      apt-get install -y kubectl
                  """
              }
          }
      }
    }
}
