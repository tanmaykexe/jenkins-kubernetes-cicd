pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'tanmaykexe/jenkins-demo-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

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
                sh 'test -f app.txt'
                sh 'grep -q "Hello from GitHub!" app.txt'
                echo 'Tests passed!'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                sh 'docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${DOCKER_IMAGE}:latest
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Docker container...'
                sh 'docker rm -f jenkins-demo-container || true'
                sh 'docker run -d --name jenkins-demo-container -p 8081:80 ${DOCKER_IMAGE}:${DOCKER_TAG}'
            }
        }
    }
}
