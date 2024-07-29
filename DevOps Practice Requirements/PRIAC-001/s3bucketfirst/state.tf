resource "aws_kms_key" "terraform-bucket-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "tims-eksle-state-bucket"
  tags = {
    Name = "MyTerraformStateBucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfbucket" {
  bucket = aws_s3_bucket.terraform-state.bucket

  rule {
    apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
       sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.terraform-state.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.terraform-state.id
  rule {
    object_ownership = "ObjectWriter"
  }
}






resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.terraform-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform-state" {
 name           = "eks-terraform-state"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}
resource "aws_kms_alias" "key-alias" {
 name          = "alias/dev-tf-tims-key"
 target_key_id = aws_kms_key.terraform-bucket-key.key_id
}