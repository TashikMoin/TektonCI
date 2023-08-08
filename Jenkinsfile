pipeline {
  agent any
  stages {
    stage('Stage') {
      steps {
        checkout scm
        tektonCreateRaw(inputType: 'FILE', input: 'pipelinerun_from_jenkins.yaml')
      }
    }
  }
}