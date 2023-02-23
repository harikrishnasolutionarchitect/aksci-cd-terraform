pipeline {
  agent any
  stages {
    stage('checkout scm') {
      steps{
      checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'git \'https://github.com/harikrishnapalakila/aksapi.git\'']])
    }
    }
  
  }

}
