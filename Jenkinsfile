Jenkinsfile (Declarative Pipeline)
pipeline {
    agent any

    stages {

        stage('Deploy') {
            steps {
                export VERSION=$BUILD_NUMBER
                chmod +x ./scripts/deploy.sh
                ./scripts/deploy.sh
            }
        }
    }
}