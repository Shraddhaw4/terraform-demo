pipeline {
    environment {
          AWS_ACCESS_KEY_ID     = credentials('creds')
          AWS_SECRET_ACCESS_KEY = credentials('creds')
    }

   agent {label 'terraform'}
   parameters {
        choice(choices:['apply','destroy'], description: 'Users Choice', name: 'action')
        booleanParam defaultValue: false, description: 'Auto Cleanup', name: 'AutoCleanup'
        extendedChoice name: 'states', description: 'Choose one state', defaultValue: 'mah', type: 'PT_RADIO', descriptionPropertyValue: 'Maharashtra,Gujarat,Dehradun', value: 'mah,guj,deh'
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
        stage('User') {
            steps {
                wrap([$class: 'BuildUser']) {
                  script {
                     USER_ID = "${BUILD_USER}"
                  }
                }
                echo "User is : ${USER_ID}"
            }
        }
       stage('Init') {
            steps {
                sh 'echo ${states}'
                sh 'pwd;cd terraform/ ; terraform init'
            }
        }

        stage('Plan') {
            steps {
              script {
                if (action == "apply"){
                    sh 'pwd;cd terraform/ ; terraform plan -var="user=${USER_ID}" -out myplan'
                } else {
                    sh 'pwd;cd terraform/ ; terraform plan -var="user=${USER_ID}" -destroy -out myplan'
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
                sh 'pwd;cd terraform/ ; terraform ${action} -var="user=${USER_ID}" --auto-approve'
            }
        }
        stage('Auto') {
            when {
                expression {params.AutoCleanup == true} 
            }
            steps {
                script {
                    def targetTime = new Date()
                    targetTime.setHours(7)
                    targetTime.setMinutes(10)
                    targetTime.setSeconds(0)
                    def targetMillis = targetTime.time
                    while (true) {
                        def now = new Date()
                        def currentMillis = now.time
                        if (currentMillis >= targetMillis) {
                            build job: "Python", wait: true, parameters: [string(name: 'test', value: "${params.action}"), string(name: 'states', value: "${params.states}")]
                            break
                        }
                        else {
                            echo "Current time ${now}, waiting for correct time"
                            sleep time: 60, unit: 'SECONDS'
                        }
                    }
                }
            }
        }
    }
}
