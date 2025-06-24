pipeline {
  agent any
  environment {
    IMAGE_NAME = 'ghcr.io/c4xp/devops05'
    TAG = "v1.0.${BUILD_NUMBER}"
  }
  stages {
    stage('Verify tools') {
      steps {
        sh 'docker info'
        sh 'mvn -v'
        sh 'kubectl version --client'
      }
    }
    stage('Build') {
      steps {
        sh 'javac HelloWorld.java'
      }
    }
    stage('Test') {
      steps {
        sh 'java HelloWorld'
      }
    }
    stage('Docker Build') {
      steps {
        script {
          docker.withRegistry('https://ghcr.io', 'github-mlcv-token') {
            def customImage = docker.build("ghcr.io/c4xp/devops05:${TAG}", "-f Dockerfile .")
            customImage.push()
            customImage.push("latest")
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(
            configs: 'kubernetes/*.yml',
            kubeconfigId: 'kubeconfig-mlcv-demo'
          )
        }
      }
    }
  }
}
