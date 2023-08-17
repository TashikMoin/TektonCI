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
        container('enabler') {
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
            pipelineRun = sh(
                script: "kubectl get pipelineruns -o=jsonpath={.items[*].metadata.name} -l pipelineRunName=${serviceName}-${BUILD_NUMBER} -n default",
                returnStdout: true
            ).trim()
            curl -X GET http://20.54.100.130/apis/tekton.dev/v1/namespaces/default/pipelineruns/${pipelineRun}
            def data = readJSON(text: env.JSON_RESPONSE)
            echo "${data}"
            def taskNames = data.status.pipelineSpec.tasks.collect { it.name }
            echo "${taskNames}"
            def prefixedTaskNames = taskNames.collect { "${pipelineRun}-${it}" }
            echo "Prefixed Task Names: ${prefixedTaskNames.join(', ')}"
          }
        }
      } 
    }
  }
}
