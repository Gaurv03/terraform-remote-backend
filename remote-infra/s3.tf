resource "aws_s3_bucket" "remote_s3" {
    bucket = "vinter-state-bucket"
    tags = {
        Name =  "vinter-state-bucket"
    }
}