pipeline {
  agent {
    docker {
      image 'jenkins-builder:latest'
      args '-v /var/run/docker.sock:/var/run/docker.sock'
    }

  }
  stages {
    stage('testing') {
      steps {
        sh 'echo "hello from builder agent"'
      }
    }

  }
}