pipeline {
  agent any
  environment {
  acr_registry = "apinode"
  }
  stages {
    stage('checkout scm') {
      steps{
      checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_creds', url: 'https://github.com/harikrishnapalakila/aksapi.git']])
    }
    }
    stage("ce-terraform-cms-api-build") {
            steps {
                script {
                  cmsapi = docker.build("${acr_registry}:${env.BUILD_ID}")
                    
                }
            }
        }
    stage("ce-terraform-cms-api-push") {
            steps {
                script {
                  // This step should not normally be used in your script. Consult the inline help for details.
                 withDockerRegistry(credentialsId: 'ACR', url: 'http://apinode.azurecr.io') {
                            cmsapi.push("latest")
                            cmsapi.push("${env.BUILD_ID}")
                    }
                }
            }
        }
  
  }

}
