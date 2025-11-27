pipeline {
  agent {
    docker {
      args '-v/var/run/docker.sock:/var/run/docker.sock'
      image 'jenkins-builder:latest'
    }

  }
  stages {
    stage('Prepare sources') {
      steps {
        sh 'git clone https://github.com/aacolyte/LABS.git .'
      }
    }

    stage('Prepare packages') {
      steps {
        sh '''sudo apt-get update
sudo apt-get install -y rpm
'''
      }
    }

    stage('Run script') {
      steps {
        sh '''chmod +x script.sh
./script.sh
'''
      }
    }

  }
}