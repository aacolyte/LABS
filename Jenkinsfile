pipeline {
  
    agent {
        dockerfile {
            filename 'Dockerfile.builder'
            dir '.'
            label 'builder-agent'
        }
    }
  
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

    
    
    
stage('Build RPM') {
    steps {
        sh '''
            mkdir -p /home/jenkins/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
            cp /home/jenkins/script_rpm/SPECS/script.spec /home/jenkins/rpmbuild/SPECS/ &&
            cp /home/jenkins/script_rpm/SOURCES/script.sh /home/jenkins/rpmbuild/SOURCES/ &&
            rpmbuild -bb /home/jenkins/rpmbuild/SPECS/script.spec --define '_topdir /home/jenkins/rpmbuild'
        "
            mkdir -p rpms/
            cp -r /home/jenkins/rpmbuild/RPMS ./rpms/
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
            dpkg-deb --build /home/jenkins/script /home/jenkins/script.deb
            mkdir -p debs
            cp script.deb debs/
        '''
    }
    post {
        always {
            archiveArtifacts artifacts: 'debs/**/*.deb', fingerprint: true
        }
    }
}
stage('Install DEB and Run Script') {
    steps {
         sh '''
            sudo dpkg -i /home/jenkins/script.deb
            sudo chmod +x /usr/bin/script.sh
            sudo /usr/bin/script.sh 
        "
        '''
    }
}
stage('Push Artifacts to Repo') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'mytoken', usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
            sh '''
                mkdir -p artifacts/rpms artifacts/debs
                
                cp rpms/noarch/*.rpm artifacts/rpms/
                
                cp debs/*.deb artifacts/debs/

                cp artifacts/rpms/*.rpm .
                cp artifacts/debs/*.deb .
                git config user.email "aacolyytee@gmail.com"
                git config user.name "aacolyte"
                git add *.rpm *.deb || true
                git commit -m "Add built RPMs and DEBs" || true
                git push https://$USER:$TOKEN@github.com/aacolyte/LABS.git
            '''
        }
    }
}
    
  }
}
