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

        stage('Manual Step') {
            steps('Input') {
                echo "choice: ${CHOICE}"
                echo "choice params.: " + params.CHOICE
                echo "choice env: " + env.CHOICE
            }
        }

        stage('Plan Apply') {
            when {
                expression { env.CHOICE == 'apply' }
            }

            steps('Execute')    {
                sh 'pwd;cd terraform/ ; terraform plan -out myplan'
            }
        }

        stage('Plan Destroy') {
            when {
                expression { env.CHOICE == 'destroy' }
            }

            steps('Execute')    {
                sh 'pwd;cd terraform/ ; terraform plan -destroy -out myplan'
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
