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
	        sh 'test -f app.txt'
	        sh 'grep -q "Hello from GitHub!" app.txt'
	        echo 'Tests passed!'
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
	        echo 'Deploying Docker container...'
	        sh 'docker rm -f jenkins-demo-container || true'
	        sh 'docker run -d --name jenkins-demo-container -p 8081:80 jenkins-demo-app'
            }
        }
    }
}
