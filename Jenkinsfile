pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "hoannv261/fastapi-app"
        DOCKER_TAG = "${env.BUILD_ID}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/viethoan261/fastapi.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build --no-cache \
                        -t ${DOCKER_IMAGE}:${DOCKER_TAG} \
                        -t ${DOCKER_IMAGE}:latest .
                    """
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh "docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} python -m pytest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh '''
                        echo $DOCKERHUB_CREDENTIALS_PSW | \
                        docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    sh """
                        cd /var/lib/jenkins/workspace/fastapi-cicd && \
                        TAG=${DOCKER_TAG} \
                        docker-compose pull && \
                        docker-compose down && \
                        docker-compose up -d
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
        }
    }
}