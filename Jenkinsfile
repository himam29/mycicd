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
          def trivyOutput = sh(script: "trivy image --config trivy.yaml myrepo:latest", returnStdout: true).trim()
             // Display Trivy scan results
             println trivyOutput
        }
      }
    }
  }
}
