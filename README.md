# DevOps05 - CI/CD with Jenkins, Docker, and Kubernetes (k3d)

This repository demonstrates a minimal CI/CD pipeline using:
- **Jenkins** (running on Synology)
- **Docker** (for image building)
- **GitHub Container Registry (GHCR)** for image storage
- **k3d** for a lightweight Kubernetes cluster
- **GitHub** for source code and Jenkinsfile

## 🛠️ Prerequisites & Setup

### 🔧 Homebrew Installs (macOS)

```bash
brew install docker
brew install k3d
brew install kubectl
brew install coreutils
brew install bash
```

### 🐳 Docker Version

```bash
docker --version
# Client: Version: 28.1.1
```

### 🔗 Create k3d Cluster (Mac mini IP: 192.168.0.145)

```bash
k3d cluster create mlcv-demo-cluster \
  --servers 1 \
  --agents 0 \
  --port "30580-30582:30580-30582@loadbalancer"
```

## 🚀 Jenkins Pipeline

Jenkins is hosted on Synology. The pipeline is defined in a `Jenkinsfile` committed to this repo.

### Jenkinsfile (Summary)

```groovy
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
    stage('Checkout') {
      steps {
        checkout scm
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
            def image = docker.build("${IMAGE_NAME}:${TAG}", "-f Dockerfile .")
            image.push()
            image.push("latest")
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-mlcv-demo', variable: 'KUBECONFIG')]) {
          sh 'kubectl apply --validate=false --insecure-skip-tls-verify -f kubernetes/'
        }
      }
    }
  }
}
```

## 🐋 Dockerfile

```Dockerfile
FROM openjdk:17
WORKDIR /app
COPY HelloWorld.java .
RUN javac HelloWorld.java
EXPOSE 80
CMD ["java", "HelloWorld"]
```

## ☸️ Kubernetes Resources

### `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld
spec:
  replicas: 1
  selector:
    matchLabels:
      app: helloworld
  template:
    metadata:
      labels:
        app: helloworld
    spec:
      containers:
        - name: helloworld
          image: ghcr.io/c4xp/devops05:latest
          ports:
            - containerPort: 80
      imagePullSecrets:
        - name: github-mlcv-token
```

### `service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
spec:
  selector:
    app: helloworld
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30580
```

## ✅ Deployment Success Check

```bash
kubectl get pods
kubectl logs <pod-name>
kubectl get svc
curl http://192.168.0.145:30580
```
