data "aws_kms_alias" "DiskEncryptionKey" {
  name = "alias/${var.kms_key_alias}"
}