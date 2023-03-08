pipeline {
  agent any
  tools { 
        maven 'maven3'
    }
  environment {
  registryName = "appapinode"
  registryUrl = "appapinode.azurecr.io"
  registryCredential = 'ACR'
  appapinode = '' 
	  
	  
	  
  }
  stages {
    stage('checkout scm') {
      steps{
      checkout([$class: "GitSCM", branches: [[name: '*/master']], git_URL: 'https://github.com/harikrishnapalakila/aksapicd.git'])
    }
    }
	  stage('SAST') {
		  steps{
		  sh """
                        mvn clean test // Execute maven
                    """	  
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
		      docker.withRegistry("http://appapinode.azurecr.io", registryCredential) {
	             appapinode.push("${BUILD_ID}")
	             appapinode.push('latest')
	 }
	      }
    }
    }
    stage('ce-terraform-cms-api-deployment-preprod') {
      steps {
        script {
          kubernetesDeploy configs: '*.yml', kubeconfigId: 'kubeconfig'
        }
      }
    } 
   }
   }
