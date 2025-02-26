pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "hoannv261/fastapi-app"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/viethoan261/fastapi.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_ID} ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh "docker run --rm ${DOCKER_IMAGE}:${BUILD_ID} python -m pytest"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_ID}"
                }
                sh 'docker-compose down && docker-compose up -d'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}