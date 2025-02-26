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
                script {
                    sh "docker run --rm ${DOCKER_IMAGE}:${BUILD_ID} python -m pytest"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Kiểm tra credentials
                    def credentials = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
                        com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
                        Jenkins.instance,
                        null,
                        null
                    )
                    echo "Available credentials: ${credentials}"
                    
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