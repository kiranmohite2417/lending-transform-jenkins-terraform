pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }

  parameters {
    choice(name: 'ACTION', choices: ['plan','apply','destroy'], description: 'Terraform action')
  }

  stages {
    stage('Initialize') {
      steps {
        sh 'terraform init -input=false'
      }
    }
    stage('Validate') {
      steps {
        sh 'terraform validate'
      }
    }
    stage('Plan') {
      when { anyOf { expression { params.ACTION == 'plan' }; expression { params.ACTION == 'apply' } } }
      steps {
        sh 'terraform plan -out tfplan -input=false'
      }
    }
    stage('Apply') {
      when { expression { params.ACTION == 'apply' } }
      steps {
        sh 'terraform apply -input=false -auto-approve tfplan || terraform apply -input=false -auto-approve'
      }
    }
    stage('Destroy') {
      when { expression { params.ACTION == 'destroy' } }
      steps {
        sh 'terraform destroy -auto-approve'
      }
    }
  }
}
