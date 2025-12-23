terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ---------------- ECS CLUSTER ----------------
resource "aws_ecs_cluster" "strapi" {
  name = "akhil-strapi-ecs"
}

# ---------------- CLOUDWATCH LOG GROUP ----------------
resource "aws_cloudwatch_log_group" "strapi" {
  name              = "/ecs/akhil-strapi"
  retention_in_days = 7
}

# ---------------- TASK DEFINITION (PLACEHOLDER) ----------------
resource "aws_ecs_task_definition" "strapi" {
  family                   = "akhil-strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.image_uri
      essential = true

      portMappings = [
        {
          containerPort = 1337
        }
      ]

      environment = [
        { name = "NODE_ENV", value = "production" },

        # ---- SQLITE CONFIG ----
        { name = "DATABASE_CLIENT", value = "sqlite" },
        { name = "DATABASE_FILENAME", value = "/tmp/data.db" },

        # ---- STRAPI SECRETS ----
        { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret },
        { name = "JWT_SECRET", value = var.jwt_secret },
        { name = "APP_KEYS", value = var.app_keys },
        { name = "API_TOKEN_SALT", value = var.api_token_salt },
        { name = "TRANSFER_TOKEN_SALT", value = var.transfer_token_salt },
        { name = "ENCRYPTION_KEY", value = var.encryption_key }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.strapi.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
