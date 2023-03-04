pipeline {
  agent {
    label 'Jenkins-build-slave'
   }
  environment {
  git_creds = "git_creds"
  git_url   = "https://github.com/harikrishnapalakila/aksapicd.git"
  acr_registryName = "appapinode"
  acr_url = "appapinode.azurecr.io"
  appapi = '' 
	  
   
	  
  }
  stages {
    stage('checkout scm') {
      steps{
      checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_creds', url: '$git_url']])
    }
    }
    stage('maven build') {
      steps{
       sh 'maven clean install'
    }
    }
    stage('Docker build') {
	    steps{
      appapinode = docker.build(acr_registryName)	  
    }
    }
    stage('Docker push ') {
      steps{
	 docker.withRegistry(url: acr_url, credentialsId: ACR) {
	  appapinode = docker.image(acr_url)
	  docker.push("${BUILD_ID}")
	  docker.push('latest')
	  }
    }
    }
    stage('ce-terraform-cms-api-deployment-preprod') {
      steps {
        script {
          kubernetesDeploy(configs: "deploymentservice.yml", kubeconfigId: "kubeconfig", enableConfigSubstitution: true)
        }
      }
    } 
   }
}
