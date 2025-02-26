pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "hoannv261/fastapi-app:latest"
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
                    // Xóa tất cả images cũ
                    sh "docker images -a | grep 'hoannv261/fastapi-app' | awk '{print \$3}' | xargs -r docker rmi -f"
                    
                    // Build với timestamp để tránh cache
                    def BUILD_DATE = sh(script: 'date -u +"%Y-%m-%dT%H:%M:%SZ"', returnStdout: true).trim()
                    
                    sh """
                        docker build --no-cache \
                        --build-arg BUILD_DATE=${BUILD_DATE} \
                        --build-arg VERSION=${BUILD_ID} \
                        -t ${DOCKER_IMAGE} .
                    """
                    
                    // Kiểm tra image mới
                    sh "docker inspect ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh "docker run --rm ${DOCKER_IMAGE} python -m pytest"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
                sh 'docker-compose down && docker-compose up -d'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            // Clean up old images
            sh "docker images -a | grep 'hoannv261/fastapi-app' | awk '{print \$3}' | xargs -r docker rmi -f || true"
        }
    }
}