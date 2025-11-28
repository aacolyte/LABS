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
        sh '''
        docker run --name builder_tmp -u 0 jenkins-builder:latest bash -c "
            mkdir -p /home/jenkins/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
            cp /home/jenkins/script_rpm/SPECS/script.spec /home/jenkins/rpmbuild/SPECS/ &&
            cp /home/jenkins/script_rpm/SOURCES/script.sh /home/jenkins/rpmbuild/SOURCES/ &&
            rpmbuild -bb /home/jenkins/rpmbuild/SPECS/script.spec --define '_topdir /home/jenkins/rpmbuild'
        "
        docker cp builder_tmp:/home/jenkins/rpmbuild/RPMS $WORKSPACE/rpms
        docker rm builder_tmp
        '''
    }
    post {
        always {
            archiveArtifacts artifacts: 'rpms/**/*.rpm', fingerprint: true
        }
    }
}
stage('Build DEB') {
    steps {
        sh '''
        docker rm -f builder_tmp_deb || true

        docker run --name builder_tmp_deb -u 0 jenkins-builder:latest bash -c "
            dpkg-deb --build /home/jenkins/script /home/jenkins/script.deb
        "

        mkdir -p $WORKSPACE/debs

        docker cp builder_tmp_deb:/home/jenkins/script.deb $WORKSPACE/debs/script.deb

        docker rm builder_tmp_deb
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
        withCredentials([usernamePassword(credentialsId: 'mytoken', usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
            sh '''
                mkdir -p artifacts/rpms artifacts/debs
                
                cp rpms/noarch/*.rpm artifacts/rpms/
                
                cp debs/*.deb artifacts/debs/
            '''
        }
    }
}
    
  }
}
