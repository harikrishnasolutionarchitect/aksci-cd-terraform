pipeline {
  agent any
  environment {
  git_creds = "git_creds"
  git_url   = "https://github.com/harikrishnapalakila/aksapicd.git"
  registryName = "appapinode"
  registryUrl = "appapinode.azurecr.io"
  registryCredential = 'ACR'
  appapinode = '' 
	  
   
	  
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
		    script {
      appapinode = docker.build registryName	  
		    }
    }
    }
    stage('Docker push ') {
      steps{
	      script {
		      docker.withRegistry("http://${acr_url}", registryName) {
	             appapinode.push("${BUILD_ID}")
	             appapinode.push('latest')
	 }
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
