pipeline {
  agent {
    docker {
      args '-v/var/run/docker.sock:/var/run/docker.sock'
      image 'jenkins-builder:latest'
    }

  }
  stages {
    stage('test stage') {
      steps {
        sh '''echo "Hello from builder"
whoami
ls -la
'''
      }
    }

  }
}