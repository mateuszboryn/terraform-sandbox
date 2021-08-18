variable "env" {default="dev"}
variable "app_long" {default="TFSandbox"}
variable "app" {default="TFSandbox"}
variable "s3_notifications_list" {
  default = {
    "dira" = {
      "topic" = "arn:aws:sns:eu-west-1:541147820420:zzz-s3-notify"
      "prefix" = "dir-a-2"
    }
    "dirb" = {
      "topic" = "arn:aws:sns:eu-west-1:541147820420:zzz-s3-notify"
      "prefix" = "dir-b-2"
    }

    }

}