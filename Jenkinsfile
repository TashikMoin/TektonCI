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
                  sh "curl -LO 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl'"
                  sh "curl -LO 'https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256'"
                  sh "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl"
                  sh "chmod +x kubectl"
                  sh "mkdir -p ~/.local/bin"
                  sh "mv ./kubectl ~/.local/bin/kubectl"
                  sh "kubectl version"
              }
          }
      }
    }
}
