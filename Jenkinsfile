pipeline {
  agent {
    label 'SFDeployJenkins01'
   }
  environment {
  acr_registryName = "apinode"
  acr_url = "apinode.azurecr.io"
  acrCredentail = 'ACR'
  cmsapi = '' 
   
  }
  stages {
    stage('checkout scm') {
      steps{
      checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_creds', url: 'https://github.com/harikrishnapalakila/aksapicd.git']])
    }
    }   
    
    
    
    stage('ce-terraform-cms-api-deployment-preprod') {
      steps {
        script {
          kubernetesDeploy(configs: "*.yml", kubeconfigId: "kubeconfig", enableConfigSubstitution: true)
        }
      }
    }
    
    
    
    
    
    
  
  }

}
