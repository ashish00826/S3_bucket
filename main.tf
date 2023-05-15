provider "aws" {
  region = "us-east-1"  
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "ashish-bucket-12345"  
  tags = {
    Name = "Ashish Bucket"
  }
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "s3_role"
}

resource "aws_iam_role" "my_instance_role" {
  name = "s3_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "my_instance_role_attachment" {
  role       = "S3_Role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  

  depends_on = [aws_iam_role.my_instance_role]
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0889a44b331db0194" 
  instance_type = "t2.micro" 

  iam_instance_profile = aws_iam_instance_profile.my_instance_profile.name

  tags = {
    Name = "My Instance"
  }
}
