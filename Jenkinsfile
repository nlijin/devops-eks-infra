pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "ap-south-1"
    AWS_CREDENTIALS = credentials('aws-creds')       // Jenkins credentials ID
    ECR_REPO = "devops-eks-app"
    CLUSTER_NAME = "devops-eks-demo"
  }

  stages {
    stage('Checkout Code') {
      steps {
        git branch: 'main', url: 'https://github.com/nlijin/devops-eks-infra.git'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir('terraform') {
          sh '''
            terraform init -input=false
            terraform plan -out=tfplan -input=false
            terraform apply -auto-approve tfplan
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh '''
            IMAGE_TAG=$(date +%Y%m%d%H%M%S)
            echo "Building image: $IMAGE_TAG"
            docker build -t ${ECR_REPO}:$IMAGE_TAG .
            echo $IMAGE_TAG > image_tag.txt
          '''
        }
      }
    }

    stage('Login to ECR & Push Image') {
      steps {
        script {
          sh '''
            IMAGE_TAG=$(cat image_tag.txt)
            aws ecr get-login-password --region ${AWS_DEFAULT_REGION} \
              | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

            ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
            docker tag ${ECR_REPO}:$IMAGE_TAG $ACCOUNT_ID.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:$IMAGE_TAG
            docker push $ACCOUNT_ID.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy to EKS via Helm') {
      steps {
        script {
          sh '''
            IMAGE_TAG=$(cat image_tag.txt)
            ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

            aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} --name ${CLUSTER_NAME}

            helm upgrade --install devops-eks-app ./helm-chart \
              --set image.repository=$ACCOUNT_ID.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO} \
              --set image.tag=$IMAGE_TAG \
              --namespace default
          '''
        }
      }
    }
  }

  post {
    always {
      echo 'Cleaning workspace...'
      cleanWs()
    }
    success {
      echo '✅ Deployment successful!'
    }
    failure {
      echo '❌ Pipeline failed!'
    }
  }
}

