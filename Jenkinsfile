pipeline {
  agent any
  tools {
    maven "MyMaven"
  }
  environment {
    VERSION = "${env.BUILD_ID}"
    NAME = "registry.gitlab.com/mylearning362622/mysample"
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
    stage('push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'gitlabproj', usernameVariable: 'GL_USERNAME', passwordVariable: 'GL_PASSWORD')]) {
	  sh 'docker login registry.gitlab.com -u $GL_USERNAME -p $GL_PASSWORD '
          sh 'docker build -t ${NAME}:${VERSION} .'
          sh 'docker push ${NAME}:${VERSION}'
	}
      }
    }
    stage('Update Tag in Helm Repo') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'gitlabproj', usernameVariable: 'GL_USERNAME', passwordVariable: 'GL_PASSWORD')]) {
          sh 'git config credential.helper cache'
          git branch: 'main', credentialsId: 'gitlabproj', url: 'https://gitlab.com/mylearning362622/mysample.git'
          echo 'Updating Image TAG'
          sh 'sed -i "s/mysample:.*/mysample:${VERSION}/g" helm_app_dir/values.yaml'
          echo 'Git Config'
          sh 'git config --global user.email "Jenkins@company.com"'
          sh 'git config --global user.name "Jenkins-ci"'
          sh 'git add helm_app_dir/values.yaml'
          sh 'git commit -m "Update Image tag to ${VERSION}"'
          sh 'git push https://gitlab.com/mylearning362622/mysample.git'
	  sh 'git config --unset credential.helper'
         // sh 'git push --set-upstream origin main'

        }
      }
    }

  }
}
