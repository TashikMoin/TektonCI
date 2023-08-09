def COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true)

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
            sh '''
            'sed -i "s/<COMMIT>/${COMMIT}/" pipelinerun_from_jenkins.yaml';
            'sed -i "s/<TAG>/${BUILD_NUMBER}/" pipelinerun_from_jenkins.yaml';
            kubectl apply -f pipelinerun_from_jenkins.yaml;
            '''
          }
        } 
      }
    }
}