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
	  stage('SAST'){
		  steps {
		  echo "================== SAST==================="
	          sh '''
		   docker run -d --rm --volume \$(pwd) -p 9000:9000 sonarqube	

		   '''		  
		  }
	  }
	  
	  stage ("sonar-publish"){
			steps {
				echo "===========Performing Sonar Scan============"
				script {
                                scannerHome = tool 'sonar'
                                 }
				withSonarQubeEnv('sonar')
				sh "${tool("sonar")}/bin/sonar-scanner"
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
    stage('ce-terraform-cms-api-deployment-preprod') {
      steps {
        script {
		echo "===========Kubernetes Deployment============"
          kubernetesDeploy configs: '*.yml', kubeconfigId: 'kubeconfig'
        }
      }
    } 
   }
   }
