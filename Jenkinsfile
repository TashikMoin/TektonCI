def url = "ssh://git@github.com/JohndoeWorkflow/Johndoe_Java_Microservice.git"
def image = "tashikmoin/johndoe-java-microservice"
def dockerfile = "/workspace/source/"
def context = "./" 
def imageBuilder = "gcr.io/kaniko-project/executor:v1.5.1"
def pipelineName = "johndoe"
def environmentName = "dev"
def serviceName = "johndoe"

pipeline {
  agent {
    kubernetes {
      yamlFile 'Agent.yaml'
    }
  }
  environment {
      gitVersion = sh(returnStdout: true, script: 'git describe --always --tags').trim()
  }
  stages {
    stage('Invoke tekton pipeline using curl') {   
      steps {
        container('enabler') {
          script {
            def event = sh(
                returnStdout: true,
                script: """
                  curl -v \\
                  -H 'Content-Type: application/json' \\
                  -H 'Connection: close' \\
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
                  }' \\
                  http://el-johndoe-event-listener.default.svc.cluster.local:80
                """
            ).trim()
            def eventJson = readJSON(text: event)
            def eventID = eventJson.eventID
            def pipelineRun = sh(
                script: "kubectl get pipelineruns -o=jsonpath={.items[*].metadata.name} -l triggers.tekton.dev/triggers-eventid=${eventID} -A",
                returnStdout: true
            ).trim()
            def pipelineRunNamespace = sh(
                script: "kubectl get pipelineruns -o=jsonpath={.items[*].metadata.namespace} -l triggers.tekton.dev/triggers-eventid=${eventID} -A",
                returnStdout: true
            ).trim()
            def jsonResponse = sh(
                returnStdout: true,
                script: "curl -X GET http://20.54.100.130/apis/tekton.dev/v1/namespaces/${pipelineRunNamespace}/pipelineruns/${pipelineRun}"
            ).trim()
            def data = readJSON(text: jsonResponse)
            def taskNames = data.status.pipelineSpec.tasks.collect { it.name }
            def pods = taskNames.collect { "${pipelineRun}-${it}-pod" }
            for(i=0; i<pods.size(); i++){
              def logsAvailable = false
              while(true){
                def podPhase = ""
                def podExists = sh(
                    returnStatus: true,
                    script: "kubectl get pod ${pods[i]} -n ${pipelineRunNamespace}"
                )
                if (podExists == 0) {
                  podPhase = sh(
                      returnStdout: true,
                      script: "kubectl get pod ${pods[i]} -n ${pipelineRunNamespace} -o jsonpath='{.status.phase}'"
                  )
                  if (podPhase == "Running" || podPhase == "Succeeded" || podPhase == "CrashLoopBackOff" || podPhase == "Error") {
                      logsAvailable = true
                      break
                  }
                }
              }
              sh "kubectl logs -f ${pods[i]} -n ${pipelineRunNamespace} --all-containers=true"
            }
          }
        }
      } 
    }
  }
}
