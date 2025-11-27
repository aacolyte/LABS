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
        sh 'docker build -t jenkins-builder:latest .\''
      }
    }

    stage('Run Script in Builder') {
      steps {
        sh '''   docker run --rm -v $PWD:/workspace -w /workspace jenkins-builder:latest bash -c "
                if [ -f package.rpm ]; then
                    sudo rpm -ivh package.rpm
                fi
                if [ -f package.deb ]; then
                    sudo dpkg -i package.deb || sudo apt-get install -f -y
                fi
                ./script.sh
                "'''
      }
    }

  }
}