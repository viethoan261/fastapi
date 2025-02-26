pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "hoannv261/fastapi-app"
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
                sh 'python -m pytest'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                        sh "docker push ${DOCKER_IMAGE}:${BUILD_ID}"
                    }
                }
                sh 'docker-compose down && docker-compose up -d'
            }
        }
    }
}