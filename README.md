# Jenkins CI/CD Pipeline with Docker

A hands-on CI/CD project demonstrating how Jenkins can automate the complete application delivery workflow — from a GitHub code change to Docker image creation, Docker Hub publishing, container deployment, and deployment verification.

## Project Overview

This project uses Jenkins to automate the following workflow:

GitHub → Jenkins → Build → Test → Docker Build → Docker Hub → Deploy → Verify

Whenever a change is detected in the GitHub repository, Jenkins automatically triggers the pipeline using SCM polling.

The pipeline then:

1. Checks out the latest source code from GitHub.
2. Builds the application.
3. Runs basic automated tests.
4. Builds a Docker image.
5. Tags the image with the Jenkins build number.
6. Pushes the image to Docker Hub.
7. Deploys the new Docker image as a container.
8. Verifies that the deployed application is running and responding correctly.

---

## Architecture

```text
                 GitHub
                   │
                   │ SCM Polling
                   ▼
                Jenkins
                   │
                   ▼
              ┌─────────┐
              │  Build  │
              └────┬────┘
                   │
                   ▼
              ┌─────────┐
              │  Test   │
              └────┬────┘
                   │
                   ▼
           ┌───────────────┐
           │ Docker Build  │
           └───────┬───────┘
                   │
                   ▼
           ┌───────────────┐
           │  Docker Hub   │
           │   Push Image  │
           └───────┬───────┘
                   │
                   ▼
             Docker Host
                   │
                   ▼
        jenkins-demo-container
                   │
                   ▼
              Port 8081
                   │
                   ▼
          Deployment Verification
Technologies Used
Jenkins
Git
GitHub
Linux
WSL2
Bash
Docker
Docker Hub
Nginx
Project Structure
jenkins-demo/
│
├── Jenkinsfile
├── Dockerfile
├── app.txt
└── README.md
Jenkinsfile

Contains the complete Jenkins Declarative Pipeline.

Dockerfile

Defines the Docker image using Nginx as the base image.

app.txt

Contains the application content served by the Nginx container.

README.md

Project documentation.

CI/CD Pipeline

The Jenkins pipeline consists of the following stages:

1. Build

The pipeline checks the application content and prepares it for the next stages.

cat app.txt
2. Test

Basic automated validation is performed.

The pipeline checks that:

app.txt exists.
The expected application content is present.

Example:

test -f app.txt
grep -q "Hello from GitHub!" app.txt

If these tests fail, the remaining pipeline stages are not executed.

3. Docker Build

Jenkins builds the Docker image using the project's Dockerfile.

Images are tagged using the Jenkins build number:

tanmaykexe/jenkins-demo-app:<BUILD_NUMBER>

For example:

tanmaykexe/jenkins-demo-app:10

The image is also tagged as:

tanmaykexe/jenkins-demo-app:latest
4. Docker Push

Jenkins authenticates with Docker Hub using Jenkins-managed credentials and pushes both:

:<BUILD_NUMBER>
:latest

The build-number tag provides version traceability between Jenkins builds and Docker images.

5. Deploy

The previous application container is removed and the newly built image is deployed:

docker rm -f jenkins-demo-container || true

docker run -d \
  --name jenkins-demo-container \
  -p 8081:80 \
  tanmaykexe/jenkins-demo-app:<BUILD_NUMBER>

The application is therefore available on:

http://localhost:8081
6. Verify Deployment

After deployment, Jenkins verifies that:

The Docker container is running.
The application responds to an HTTP request.
The expected application content is returned.

Example verification:

docker ps
curl -f http://localhost:8081

The pipeline also verifies that the expected application text is present.

If the verification fails, Jenkins marks the pipeline as failed.

Docker Configuration

The project uses Nginx as the web server.

FROM nginx:alpine

COPY app.txt /usr/share/nginx/html/index.html

EXPOSE 80

The app.txt file is copied into the Nginx web root and served as the application's index.html.

Jenkins Pipeline Configuration

The Jenkins job uses:

Pipeline as Code
Jenkinsfile stored in GitHub
Git SCM
SSH-based GitHub authentication
SCM polling
Jenkins environment variables
Jenkins credentials for Docker Hub

The Jenkinsfile is retrieved directly from the GitHub repository.

Automatic Trigger

The pipeline uses Jenkins SCM polling to detect changes in the GitHub repository.

The workflow is:

Developer pushes code
        ↓
GitHub repository updated
        ↓
Jenkins SCM polling detects change
        ↓
Jenkins pipeline starts
        ↓
Build → Test → Docker Build → Push → Deploy → Verify
Docker Image Versioning

Docker images are tagged using the Jenkins build number.

For example:

Build #10
     ↓
jenkins-demo-app:10

This provides traceability between a Jenkins build and the Docker image produced by that build.

The latest tag is also updated during the pipeline.

Deployment Verification

The deployment is not considered successful merely because the Docker container starts.

The pipeline performs an HTTP request against the deployed application:

curl -f http://localhost:8081

It then verifies that the expected application content is returned.

This provides a basic post-deployment health check.

What I Learned

Through this project, I practiced:

Jenkins fundamentals
Jenkins Freestyle jobs
Jenkins Declarative Pipelines
Jenkinsfile
GitHub SCM integration
SSH authentication
Jenkins environment variables
SCM polling
Automated testing
Docker image creation
Docker image tagging
Docker Hub authentication
Docker image publishing
Docker container deployment
Deployment verification
Jenkins build retention
Basic CI/CD troubleshooting
CI/CD Flow Summary
        GitHub
           │
           ▼
     SCM Polling
           │
           ▼
        Jenkins
           │
           ▼
        Build
           │
           ▼
         Test
           │
           ▼
     Docker Build
           │
           ▼
      Docker Hub
           │
           ▼
        Deploy
           │
           ▼
   Health Verification
           │
           ▼
        SUCCESS
Future Improvements

Possible improvements for this project include:

Jenkins agents
GitHub webhooks
Improved Docker credential management
Container health checks
Automated rollback
Kubernetes deployment
Helm-based deployment
AWS deployment
Monitoring and observability

### One important thing

I've deliberately **not** claimed things like Kubernetes, AWS deployment, webhooks, rollback, etc. as completed features. They're only under **Future Improvements**.

