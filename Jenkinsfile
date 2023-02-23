pipeline {
  agent any
  environment {
  acr_registryName = "apinode"
  acr_url = "apinode.azurecr.io"
  acrCredentail = 'ACR'
  cmsapi = '' 
   
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
                  cmsapi = docker.build("${acr_registryName}:${env.BUILD_ID}")
                    
                }
            }
        }
    
    
    stage("ce-terraform-cms-api-push") {
            steps {
                script {
                  docker.withRegistry("http://${acr_url}", acrCredentail) {
                            cmsapi.push("latest")
                            cmsapi.push("${env.BUILD_ID}")
                    } 
                }
            }
        }
    
    
    // Testing docker image from acr  
	
	stage('cleanup existing containers') {
	 steps{
	   sh 'docker ps -f name=apinodehc -q | xargs --no-run-if-empty docker container stop'
	   sh 'docker container ls -a -f name=apinodehc -q | xargs -r docker container rm'	 
	 }	
	}
	
	stage('pull & spiwn containers') {
	 steps{
	   script {
	   sh 'docker run -d -p 4000:5000 --rm --name apinodehc ${acr_url}/${acr_registryName}'
	   }
	 }	
	}
    
    
  
  }

}
