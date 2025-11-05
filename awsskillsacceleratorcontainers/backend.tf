terraform {
  backend "s3" {
    bucket       = "kloudspaceplatformbubcketstate"
    key          = "awsskillsacceleratorcontainers/state"
    region       = "af-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
