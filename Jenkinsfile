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
                    sh 'sudo docker build -t ${DOCKER_IMAGE}:${BUILD_ID} .'
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
                        sh 'sudo docker login -u $DOCKER_USER -p $DOCKER_PASS'
                        sh 'sudo docker push ${DOCKER_IMAGE}:${BUILD_ID}'
                    }
                }
                sh 'sudo docker-compose down && sudo docker-compose up -d'
            }
        }
    }
}