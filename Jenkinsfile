pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }

        stage('Plan for Apply') {
            when {
                expression { env.ACTION == 'apply' }
            }
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }

        stage('Approval for Apply') {
            when {
                expression { env.ACTION == 'apply' }
            }
            steps {
                input(message: "Approve Deployment?", ok: "Yes, deploy")
            }
        }

        stage('Apply') {
            when {
                expression { env.ACTION == 'apply' }
            }
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Plan for Destroy') {
            when {
                expression { env.ACTION == 'destroy' }
            }
            steps {
                script {
                    sh 'terraform plan -destroy'
                }
            }
        }

        stage('Approval for Destroy') {
            when {
                expression { env.ACTION == 'destroy' }
            }
            steps {
                input(message: "Are you sure you want to destroy? Review the plan above.", ok: "Yes, destroy")
            }
        }

        stage('Destroy') {
            when {
                expression { env.ACTION == 'destroy' }
            }
            steps {
                script {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}

