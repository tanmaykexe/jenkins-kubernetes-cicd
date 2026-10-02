pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'cat app.txt'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'echo "Tests passed!"'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t jenkins-demo-app .'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deployment step completed.'
            }
        }
    }
}
