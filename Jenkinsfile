pipeline {
    environment {
          AWS_ACCESS_KEY_ID     = credentials('AWS_credentials')
          AWS_SECRET_ACCESS_KEY = credentials('AWS_credentials')
    }

   agent {label 'terraform'}
   parameters {
        choice(choices:['apply','destroy'], description: 'Users Choice', name: 'action')
    }
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/Shraddhaw4/terraform-demo.git"
                        }
                    }
                }
            }
       stage('Init') {
            steps {
                sh 'pwd;cd terraform/ ; terraform init'
            }
        }

        stage('Plan') {
            steps {
              script {
                if (action == "apply"){
                    sh 'pwd;cd terraform/ ; terraform plan -out myplan'
                } else {
                    sh 'pwd;cd terraform/ ; terraform plan -destroy -out myplan'
                }
              }
            }
        }
        
        stage('Approval') {
            steps {
              script {
                def userInput = input(id: 'confirm', message: 'Confirmation', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Confirmation', name: 'confirm'] ])
            }
          }
        }
        stage('Action') {
            steps {
                sh 'pwd;cd terraform/ ; terraform ${action} --auto-approve'
            }
        }
    }
}
