provider "aws" {
  region = "us-east-1"
}

# setup cloud space
resource "aws_vpc" "et_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    App         = "epoch-time"
    Environment = "Lab"
  }
}

resource "aws_subnet" "et_subnet" {
  vpc_id     = aws_vpc.et_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {

    App         = "epoch-time"
    Environment = "Lab"
  }
}

resource "aws_internet_gateway" "et_igw" {
  vpc_id = aws_vpc.et_vpc.id

  tags = {
    App         = "epoch-time"
    Environment = "Lab"
  }
}

resource "aws_route_table" "et_route_table" {
  vpc_id = aws_vpc.et_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.et_igw.id
  }

  tags = {
    App         = "epoch-time"
    Environment = "Lab"
  }
}

resource "aws_route_table_association" "et_route_table_association" {
  subnet_id      = aws_subnet.et_subnet.id
  route_table_id = aws_route_table.et_route_table.id
}

resource "aws_security_group" "et_security_group" {
  name   = "allow_http"
  vpc_id = aws_vpc.et_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    App         = "epoch-time"
    Environment = "Lab"
  }
}

resource "aws_ecs_cluster" "et_ecs_cluster" {
  name = "et_fargate_cluster"

  tags = {
    App         = "epoch-time"
    Environment = "Lab"
  }
}

resource "aws_ecs_task_definition" "et_ecs_task_definition" {
  family                   = "et_fargate_container_build_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
  [
    {
      "name": "epoch-time-container",
      "image": "techofalltrades/epoch-time-api:latest",
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ]
    }
  ]
  DEFINITION

  tags = {
    App         = "epoch-time"
    Environment = "Lab"
  }
}

resource "aws_ecs_service" "et_ecs_service" {
  name            = "et_fargate_service"
  cluster         = aws_ecs_cluster.et_ecs_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.et_ecs_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.et_subnet.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.et_security_group.id]
  }

  tags = {
    App         = "epoch-time"
    Environment = "Lab"
  }
}

output "cluster_name" {
  value = aws_ecs_cluster.et_ecs_cluster.name
}



