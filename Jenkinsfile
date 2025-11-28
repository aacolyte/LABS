pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(branch: 'main', credentialsId: 'token_token', url: 'https://github.com/aacolyte/LABS.git')
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t jenkins-builder:latest .'
      }
    }

    stage('Run Script in Builder') {
      steps {
        sh 'docker run --rm -v $WORKSPACE:/workspace -w /workspace jenkins-builder:latest bash /home/jenkins/script.sh'
      }
    }

  }
}