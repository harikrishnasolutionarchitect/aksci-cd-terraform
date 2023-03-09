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
      stage('list-version') {
		  steps {
			  
		  echo "==============================  OS Level informaiton ===================="
		  sh '''
		  pwd
		  java -version && which java
		  '''		  
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
	  
    stage('Run Playbook Gov Inventory') {
	steps {
	script {
    sh """
                    cd ansible/filebeat/
                    echo "Azure Government Authentication"
                    ansible-playbook auth_playbook.yml --extra-vars "azcloud=government"
                    echo "Azure Government Inventory"
                    ansible-inventory -i inventory_gov_azure_rm.yml --graph
                    echo "Running Playbook"
                    ansible-playbook playbook.yml -i inventory_gov_azure_rm.yml
                """
				}
				}
	}
	stage('Run Playbook Com Inventory') {
	steps {
	script {
    sh """
                    cd ansible/filebeat/
                    echo "Azure Commercial Authentication"
                    ansible-playbook auth_playbook.yml --extra-vars "azcloud=commercial"
                    echo "Azure Commercial Inventory"
                    ansible-inventory -i inventory_com_azure_rm.yml --graph
                    ##### Uncomment lines below if needed for Azure Commercial VMs
                    #echo "Running Playbook"
                    #ansible-playbook playbook.yml -i inventory_com_azure_rm.yml
                """
				}
				}
	}
	  
	  
	  
   }
   }
