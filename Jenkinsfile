pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                checkout scm
                tektonCreateRaw(input: 'pipelinerun_from_jenkins.yaml', inputType: "FILE", namespace: 'tekton-pipelines')
            }
        }
    }
}