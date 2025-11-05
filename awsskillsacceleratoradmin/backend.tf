terraform {
  backend "s3" {
    bucket       = "kloudspaceplatformbubcketstate"
    key          = "awsskillsaccelerator/state"
    region       = "af-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
