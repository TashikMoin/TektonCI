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
                sh '''
                  kubectl logs -n default -f -l pipelineRunName=johndoe-pipelinerun-${BUILD_NUMBER} --wait --all-containers --previous --max-log-requests 10000
                '''
            }
          }
        } 
      }
    }
}
