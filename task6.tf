provider "kubernetes" {
config_context_cluster =  "minikube"

resource "kubernetes_deployment" "minikube_app" {
metadata {
name = "wordpress"
labels = {
test = "wp_system"
}
}

spec {
replicas = 5
selector {
match_labels = {
env = "Development"
dc = "IN"
App = "wordpress"
}
match_expressions {
key = "env"
operator = "In"
values = ["Development", "wordpress"]
}
}
template {
metadata {
labels = {
env = "Development"
dc = "IN"
App = "wordpress"
}
}
spec {
container {
image = "wordpress"
name  = "cont"
}
}
}
}
}
resource "kubernetes_service" "service" {
metadata {
name = "loadbalancer"
}
spec {
selector = {
App = kubernetes_deployment.minikube_app.spec.0.template.0.metadata[0].labels.App
}
port {
node_port = 30000
port        = 80
target_port = 80
}
type = "NodePort"
}
}
resource "null_resource" "minikube_app" {
provisioner "local-exec" {
command = "minikube service list"
}
depends_on = [
kubernetes_deployment.minikube_app
]
}

provider "aws" {
  region = "ap-south-1"
  profile = "anubhav"
}
resource "aws_db_instance" "mydb" {
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "5.7.30"
  instance_class    = "db.t2.micro"
  name     = "mydb"
  username = "redhat"
  password = "redhat12345"
  port     = "3306"
  publicly_accessible = true
  skip_final_snapshot = true
  iam_database_authentication_enabled = true
  vpc_security_group_ids = ["sg-b2a2ead0"]
  tags = {
     Name = "mysql"
 }
}
}