def url = "ssh://git@github.com/JohndoeWorkflow/Johndoe_Java_Microservice.git"
def image = "tashikmoin/johndoe-java-microservice"
def dockerfile = "/workspace/source/"
def context = "./" 
def imageBuilder = "gcr.io/kaniko-project/executor:v1.5.1"
def pipelineName = "johndoe"
def environmentName = "dev"
def serviceName = "johndoe"
def pipelineRun = ""

pipeline {
  agent {
    kubernetes {
      yamlFile 'Agent.yaml'
    }
  }
    stages {
      stage('Invoke tekton pipeline using curl') {   

        steps {
          container('curl') {
            script {
              sh """
                curl -v \
                -H 'Content-Type: application/json' \
                -H 'Connection: close' \
                -d '{
                  "build": "'"$BUILD_NUMBER"'",
                  "url": "'"$url"'",
                  "image": "'"$image"'",
                  "revision": "'"$BUILD_NUMBER"'",
                  "dockerfile": "'"$dockerfile"'",
                  "context": "'"$context"'",
                  "imageBuilder": "'"$imageBuilder"'",
                  "pipelineName": "'"$pipelineName"'",
                  "environment": "'"$environmentName"'", 
                  "serviceName": "'"$serviceName"'"
                }' \
                http://el-johndoe-event-listener.default.svc.cluster.local:80
              """
            }
          }
        } 
      }

      stage('Tekton Pipeline Logs') {     
        steps {
          container('kubectl') {
            script {
              pipelineRun = sh(
                  script: "kubectl get pipelineruns -o=jsonpath=‘{.items[*].metadata.name}’ -l pipelineRunName=${serviceName}-${BUILD_NUMBER} -n default",
                  returnStdout: true
              ).trim()
              echo "${pipelineRun}"
              def unstructuredPodNames = sh( 
                  script: "kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l pipelineRunName=${serviceName}-${BUILD_NUMBER} -n default",
                  returnStdout: true
              ).trim() /* pod names as single array item separated by spaces example -> "[podname#1 podname#2 ...]" */ 
              def podNames = unstructuredPodNames.tokenize() /* pod names array with each pod name as its item/element separated by ',' example "[podname#1, podname#2, ...]" */
              for (int i = 1; i < podNames.size(); i++) {
                def podName = podNames[i]
                sh """
                kubectl logs -n default -f ${podName}  --all-containers
                """
                /*
                stage("Logs for ${podNames[i]}") {
                    steps {
                        echo "\n\n...Streaming logs for ${podNames[i]}...\n\n"
                        script {
                          sh """
                            kubectl logs -n default -f ${podNames[i]}  --all-containers
                          """
                        }
                    }
                }
                */
              }
            }
          }
        } 
      }
    }
}
