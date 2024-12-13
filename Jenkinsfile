pipeline {
  environment {
    dockerimagename = "brdcookies6969/dedi-python-app"
    dockerImage = ""
    KUBECONFIG = "${WORKSPACE}/kubeconfig"
  }
  agent any
  stages {
    stage('Checkout Source') {
      steps {
	      git branch: 'main',
	      credentialsId: 'token-github',
        url: 'https://github.com/deditriyadibarnawan69/dedi-python-app.git'
      }
    }
    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }
    stage('Pushing Image') {
      environment {
          registryCredential = 'dockerhub-credentials'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }
    
    stage('Prepare Kubeconfig') {
            steps {
                // Mengunduh kubeconfig dari Jenkins credentials
                withCredentials([file(credentialsId: 'kubeconfig-credential-id', variable: 'KUBECONFIG_FILE')]) {
                    sh """
                    cp $KUBECONFIG_FILE ${KUBECONFIG}
                    chmod 600 ${KUBECONFIG}
                    """
                }
            }
        }
    stage('Deploy to Kubernetes') {
          steps {
            script {
                def deploymentName = "dedi-python-app-deploy"
            
                // Cek apakah deployment sudah ada di cluster
                def isDeploymentExists = sh(
                    script: """
                    kubectl --kubeconfig=${KUBECONFIG} get deployment ${deploymentName} -o name || true
                    """,
                returnStdout: true
            ).trim()

            if (isDeploymentExists) {
                echo "Deployment '${deploymentName}' sudah ada. Melakukan restart..."
                // Jalankan rollout restart jika deployment sudah ada
                sh """
                    kubectl --kubeconfig=${KUBECONFIG} rollout restart deployment ${deploymentName}
                """
            } else {
                echo "Deployment '${deploymentName}' belum ada. Melakukan apply..."
                // Jalankan apply jika deployment belum ada
                sh """
                    kubectl --kubeconfig=${KUBECONFIG} apply -f manifest-python-app.yaml
                """
            }
        }
    }
}

    // stage('Deploy to Kubernetes') {
    //         steps {
    //             // Deploy aplikasi ke Kubernetes dengan kubectl
    //             sh """
    //             kubectl --kubeconfig=${KUBECONFIG} rollout restart deployment/dedi-java-app-deploy
    //             """
    //         }
    //     }
  
    // stage('Deploying container to Kubernetes') {
    //   steps {
    //     script {
    //       sh '''
	  //   kubectl rollout restart deployment/dedi-java-app-deploy
    //       '''
    //     }
    //   }
    // }
}
  post {
    always {
        // Membersihkan file kubeconfig setelah pipeline selesai
        sh "rm -f ${KUBECONFIG}"
      }
      success {
          echo 'Deployment successful!'
      }
      failure {
          echo 'Deployment failed!'
      }
    }
}
