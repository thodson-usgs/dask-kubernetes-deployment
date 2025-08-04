```bash
terraform init
```

## Deploy
```bash
terraform apply --var-file=hytest-us-west-2.tfvars
```
and destroy
```bash
terraform destroy --var-file=hytest-us-west-2.tfvars
```

## Ray
```bash
kubectl apply -f ray-cluster.yaml
```

## Mirror Ray Image to Amazon ECR

1. Create an ECR repository with Terraform:

```hcl
resource "aws_ecr_repository" "ray" {
  name = "ray"
}
```

2. Authenticate Docker to ECR and mirror the image:

```bash
# Get AWS account ID and region
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)

# Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Pull the Ray image from Docker Hub
IMAGE_TAG=2.46.0

docker pull rayproject/ray:$IMAGE_TAG

docker tag rayproject/ray:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ray:$IMAGE_TAG

docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/ray:$IMAGE_TAG
```

3. Update your RayCluster YAML to use the ECR image:

```yaml
image: <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/ray:2.46.0
```