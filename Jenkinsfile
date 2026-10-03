pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'tanmaykexe/jenkins-demo-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        K8S_NAMESPACE = 'jenkins-k8s-demo'
        K8S_DEPLOYMENT = 'jenkins-demo'
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

        stage('Kubernetes Deploy') {
            steps {
                echo "Deploying ${DOCKER_IMAGE}:${DOCKER_TAG} to Kubernetes..."

                sh '''
                    kubectl set image deployment/${K8S_DEPLOYMENT} \
                        jenkins-demo=${DOCKER_IMAGE}:${DOCKER_TAG} \
                        -n ${K8S_NAMESPACE}
                '''
            }
        }

        stage('Kubernetes Rollout') {
            steps {
                echo 'Waiting for Kubernetes rollout...'

                sh '''
                    kubectl rollout status deployment/${K8S_DEPLOYMENT} \
                        -n ${K8S_NAMESPACE} \
                        --timeout=120s
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying Kubernetes deployment...'

                sh '''
                    kubectl get pods -n ${K8S_NAMESPACE}

                    kubectl get deployment ${K8S_DEPLOYMENT} \
                        -n ${K8S_NAMESPACE}

                    kubectl rollout status deployment/${K8S_DEPLOYMENT} \
                        -n ${K8S_NAMESPACE} \
                        --timeout=30s
                '''

                echo 'Kubernetes deployment verified successfully!'
            }
        }
    }
}
