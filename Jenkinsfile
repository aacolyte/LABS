pipeline {
  agent any
  stages {
    stage('Clean Workspace') {
    steps {
        deleteDir()  
    }
}
    stage('Checkout') {
      steps {
        git(branch: 'main', credentialsId: 'token_token', url: 'https://github.com/aacolyte/LABS.git')
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t jenkins-builder:latest -f Dockerfile.builder .'
      }
    }

    stage('Run Script in Builder') {
      steps {
        sh 'docker run --rm -v $WORKSPACE:/workspace -w /workspace jenkins-builder:latest bash /home/jenkins/script.sh'
      }
    }
    
    stage('Check container workspace') {
    steps {
        sh """
        echo "Workspace on host: \$WORKSPACE"
        docker run --rm -v \$WORKSPACE:/workspace -w /workspace jenkins-builder:latest bash -c "
            echo 'Files and folders in /workspace inside container:'
            ls -R
        "
        """
    }
}
    
    stage('Build RPM') {
    steps {
      sh """
        docker run --rm -u 0 -v \$WORKSPACE:/workspace -w /workspace jenkins-builder:latest bash -c \"
        mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
        cp script_rpm/SPECS/script.spec rpmbuild/SPECS/ &&
        cp -r script_rpm/* rpmbuild/SOURCES/ &&
        rpmbuild -bb rpmbuild/SPECS/script.spec --define \\\"_topdir \$WORKSPACE/rpmbuild\\\"
    \"
    """
    }
    post {
        always {
            archiveArtifacts artifacts: 'rpmbuild/RPMS/**/*.rpm', fingerprint: true
        }
    }
}
    stage('Build DEB') {
                steps {
                    sh '''
                    docker run --rm -u 0 -v $WORKSPACE:/workspace -w /workspace jenkins-builder:latest bash -c "
                        mkdir -p debs/BUILD debs/DEBS &&
                        dpkg-deb --build script debs/
                    "
                    '''
                }
                post {
                    always {
                        archiveArtifacts artifacts: 'debs/**/*.deb', fingerprint: true
                    }
                }
            }
    
      stage('Push Artifacts to Repo') {
      steps {
          withCredentials([string(credentialsId: 'token_token', variable: 'GH_TOKEN')]) {
              sh '''
              mkdir -p artifacts/rpms artifacts/debs
              cp rpmbuild/RPMS/**/*.rpm artifacts/rpms/
              cp debs/**/*.deb artifacts/debs/
  
              git add artifacts/*
              git commit -m "Add build artifacts from Jenkins"

              git push https://$GH_TOKEN@github.com/aacolyte/LABS.git HEAD:main
              '''
          }
      }
  }

    
  }
}
