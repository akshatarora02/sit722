Jenkinsfile (Declarative Pipeline)
pipeline {
    agent any

    stages {

        stage('Deploy') {
            steps {
              sh 'export VERSION=$BUILD_NUMBER'
              sh 'chmod +x ./scripts/deploy.sh'
              sh './scripts/deploy.sh'
            }
        }
    }
}