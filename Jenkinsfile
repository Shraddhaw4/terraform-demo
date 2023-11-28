pipeline {
    environment {
          AWS_ACCESS_KEY_ID     = credentials('AWS_credentials')
          AWS_SECRET_ACCESS_KEY = credentials('AWS_credentials')
    }

   agent {label 'terraform'}
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
                sh 'pwd;cd terraform/ ; terraform plan -out myplan'
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
