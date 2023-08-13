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
              sh '''
                 curl -v \
                  -H 'Content-Type: application/json' \
                  -H 'Connection: close' \
                  -d '{
                    "build": "'"$BUILD_NUMBER"'",
                    "url": "ssh://git@github.com/JohndoeWorkflow/Johndoe_Java_Microservice.git",
                    "image": "tashikmoin/johndoe-java-microservice",
                    "revision": "'"$BUILD_NUMBER"'",
                    "dockerfile": "/workspace/source/",
                    "context": "./",
                    "imageBuilder": "gcr.io/kaniko-project/executor:v1.5.1",
                    "pipelineName": "johndoe",
                    "environment": "dev"
                  }' \
                  http://el-johndoe-event-listener.default.svc.cluster.local:80
              '''
            }
          }
        } 
      }

      stage('Tekton Pipeline Logs') {     
        steps {
          container('kubectl') {
            script {
              sleep 30
              def podNames = sh(script: "kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l pipelineRunName=johndoe-pipelinerun-${BUILD_NUMBER} -n default", returnStdout: true).trim().split('\n')
              echo "Found pods: ${podNames}"
              for (int i = 1; i < podNames.size(); i++) {
                  def podName = podNames[i]
                  sh'''
                  echo "Inside loop"
                  echo "${podName}"
                  kubectl logs -n default -f ${podName}  --all-containers
                  '''
              }
            }
          }
        } 
      }
    }
}
