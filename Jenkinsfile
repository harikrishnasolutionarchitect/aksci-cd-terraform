pipeline {
  agent any
  stages {
    stage('checkout scm') {
      steps{
      checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_creds', url: 'https://github.com/harikrishnapalakila/aksapi.git']])
    }
    }
  
  }

}
