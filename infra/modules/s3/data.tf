data "terraform_remote_state" "messaging" {
  backend = "s3"
  config = {
    bucket = "nextime-frame-state-bucket"
    key    = "messaging/infra.tfstate"
    region = "us-east-1"
  }
}
