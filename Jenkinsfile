pipeline {
  agent any
  tools {
    maven "MyMaven"
  }
  stages {
    stage('Checkout from GitHub') {
      steps {
        git branch: 'main', url: 'https://github.com/himam29/mycicd.git'
      }
    }
	stage ('Maven Build'){
      steps {
        sh 'mvn clean install'
      } 
    }
    stage ('Unit Test'){
      steps {
        echo '<----------------------Unit Test Under Progess------------------>'
        sh 'mvn surefire-report:report'
        echo '<----------------------Unit Test Done------------------>'
      }
    }
    stage ('Build Docker Image'){
      steps {
        script {
          sh 'docker build -t myrepo .'
        }
      }
    }
    stage('Scan Docker Image') {
      steps {
        script {
          // Run Trivy to scan the Docker image
          def trivyOutput = sh(script: "trivy image myrepo:latest", returnStdout: true).trim()

             // Display Trivy scan results
             println trivyOutput

             // Check if vulnerabilities were found
             if (trivyOutput.contains("Total: 0")) {
                 echo "No vulnerabilities found in the Docker image."
             } else {
                 echo "Vulnerabilities found in the Docker image."
                 error "Vulnerabilities found in Docker image."
          }
        }
      }
    }
  }
}
