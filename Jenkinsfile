pipeline {
  agent {
    label 'Jenkins-build-slave'
   }
  environment {
  git_creds = "git_creds"
  git_url   = "https://github.com/harikrishnapalakila/aksapicd.git"
  acr_registryName = "appapinode"
  acr_url = "appapinode.azurecr.io"
  acr_creds = 'ACR'
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
	  withDockerRegistry[url: ${acr_url}, credentialsId: '${acr_creds}']
      appapinode = docker.build("${acr_url}:${env.BUILD_ID}")	  
    }
    }
    stage('Docker push ') {
      steps{
      withDockerRegistry[url: ${acr_url}, credentialsId: '${acr_creds}'] {
	  appapinode = docker.image("${acr_url}:${env.BUILD_ID}")
	  docker.push("${BUILD_ID}")
	  docker.push('latest')
	  }
    }
    }

    #stage {
    # steps {
     #  withDockerRegistry[url: ${ACR_url}, credentialsId: ${ACR_creds} ]
     #  appapinode = docker.image("${ACR_REGISTRY}":latest)
     #  appapinode.pull()
     #  sh '''
      #     echo "Switch to Dev-node-hf folder"
      #     cd /node-k8s-hc && kubectl apply -f *
	#}
	#}
    stage('ce-terraform-cms-api-deployment-preprod') {
      steps {
        script {
          kubernetesDeploy(configs: "deploymentservice.yml", kubeconfigId: "kubeconfig", enableConfigSubstitution: true)
        }
      }
    } 
   }
}
