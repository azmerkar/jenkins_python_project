pipeline {
    agent any
    environment {
      SERVER_IP=credentials('prod-server-ip')
    }
    stages {


        stage('Setup') {
            steps {
                sh "pip install -r requirements.txt"
            }
        }
        stage('Test') {
            steps {
                echo "Commit: ${env.GIT_COMMIT}"
                echo "testing application" 
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
             sh '''
                    source ~/.bashrc
                    pytest --version
                    pytest
               '''
             } 
            }
        }
        stage('Package Code') {
            steps {
                script{
                    sh "zip -r myapp.zip ./* -x '*.git*'"
                    sh "ls -lart"
                }

             } 
        } 

        stage('Deploy to Prod') {
            steps {
              withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'MY_SSH_KEY', usernameVariable: 'username')]) {
                sh """
                pwd
                scp -i $MY_SSH_KEY -o StrictHostKeyChecking=no myapp.zip ${username}@${SERVER_IP}:/home/ec2-user/
                scp -i $MY_SSH_KEY -o StrictHostKeyChecking=no start.sh  ${username}@${SERVER_IP}:/home/ec2-user/
                ssh -i $MY_SSH_KEY -o StrictHostKeyChecking=no ${username}@${SERVER_IP} <<
                EOF
                        unzip -o /home/ec2-user/myapp.zip -d /home/ec2-user/app/
                        source /home/ec2-user/app/venv/bin/activate
                        cd /home/ec2-user/app/
                        pip install -r requirements.txt
                        sudo systemctl restart flaskapp.service 
EOF
                """
}

     
             } 
        } 

    }


    }
