pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '30'))
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
	      echo "===========SCM Checkout ============"
              checkout([$class: "GitSCM", branches: [[name: '*/master']], git_URL: 'https://github.com/harikrishnapalakila/aksapicd.git'])
	            }
    }
	 
	  stage ('Dockefile disply'){
		  steps {
	      echo "================================================================="
	      echo "===========timeout cat Dockerfile ============"
	      timeout(time: 10, unit: 'MINUTES') {
                    sh 'cat Dockerfile'
                }
		  }
	  } 
      stage('list-version') {
	      
		  steps {
			  
		  echo "==============================  OS Level informaiton ===================="
		  sh '''
		  pwd
		  java -version && which java
		  '''		  
		  }
	  }	  
	
    stage('Docker build') {
	    steps{
		    script {
			    echo "===========Docker build ============"
      appapinode = docker.build registryName	  
		    }
    }
    }
    stage('Docker push ') {
      steps{
	      script {
		      echo "===========Docker push into ACR============"
		      docker.withRegistry("http://appapinode.azurecr.io", registryCredential) {
	             appapinode.push("${BUILD_ID}")
	             appapinode.push('latest')
	 }
	      }
          }
          }    
    
	  stage('get-namespace-list'){
		  steps {
		  sh '''
		  kubectl get ns 
		  '''
		  
		  }
	  
	  }
	
	  stage('AKS-Deployment'){
		  steps {
			  script {
			  appapinode = docker.image('appapinode.azurecr.io/appapinode:latest')            
                          docker.withRegistry("http://appapinode.azurecr.io", registryCredential) {            
                          appapinode.pull()            
                          sh "kubectl create -f ."
			  }
    }
		  }
	  
	  }
   
	  
   }
   }
