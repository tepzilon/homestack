terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "6.27.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }

  backend "s3" {
    bucket  = "homestack-opentofu-state"
    key     = "main.tfstate"
    region  = "ap-southeast-1"
    profile = "homestack-iac"
  }
}

provider "oci" {
  tenancy_ocid = data.aws_kms_secrets.oci.plaintext["tenancy_ocid"]
  user_ocid    = data.aws_kms_secrets.oci.plaintext["user_ocid"]
  private_key  = data.aws_kms_secrets.oci.plaintext["private_key"]
  fingerprint  = data.aws_kms_secrets.oci.plaintext["fingerprint"]
  region       = "ap-singapore-1"
}

variable "kms_key_id" {
  type    = string
  default = "7129ecf7-823d-4dca-a8f1-7e0d8e3e2ce0"
}

data "aws_kms_secrets" "oci" {
  secret {
    name    = "tenancy_ocid"
    payload = "AQICAHhdhDx+mvb065S66mmsEOw5VGksyFAQFNIgM/njoXpYDwH5ChRgN/QPadnzRtwb/GxCAAAAsTCBrgYJKoZIhvcNAQcGoIGgMIGdAgEAMIGXBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDHsS9yMiEU+U1w8T8gIBEIBqToaPVV7T3VqgL97m7ZIj4BKpMXNG198GOUTatl1thIhRzdXSomCWkQK79tsd1+Yvu2iVsroJM2YqaAQhuUGXIPhbj4wvlnJbXJWK6pGB71IFl2NXHhyTYzfbJgioojV5/uFbb8U8xEBOXA=="
    key_id  = var.kms_key_id
  }
  secret {
    name    = "user_ocid"
    payload = "AQICAHhdhDx+mvb065S66mmsEOw5VGksyFAQFNIgM/njoXpYDwF0xFXBpwEF/84i/6UlaX/dAAAArjCBqwYJKoZIhvcNAQcGoIGdMIGaAgEAMIGUBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDG9iJ4Itz9y44jp7eQIBEIBnBfLNNTgL5tC2eD55XyYb5H0YgJymJOvVc9MHyKh1/gPwKDUv/XI9id6N4X39u1LGkb6VWH8uf+4eREX98pI+M0wRi2fjTMlHtf7l47W2RM4zdtz9/fPDEL4piFvkX29hyfE1jiCv7w=="
    key_id  = var.kms_key_id
  }
  secret {
    name    = "fingerprint"
    payload = "AQICAHhdhDx+mvb065S66mmsEOw5VGksyFAQFNIgM/njoXpYDwG5miwteR0NKe2w9hQqJjosAAAAjjCBiwYJKoZIhvcNAQcGoH4wfAIBADB3BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDL5sGsoyMYT4ruV2qgIBEIBKibfM4A2Mt7BX6d1HTpHqOX3pDPotROct6ou/pamPcOTgjxtUb4moa+7P1NDjmPc3S6SKqpQQLDyN2HuGHNGWr71ymvthLvC6L/w="
    key_id  = var.kms_key_id
  }
  secret {
    name    = "private_key"
    payload = "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"
    key_id  = var.kms_key_id
  }
}

resource "oci_identity_compartment" "homestack" {
  compartment_id = data.aws_kms_secrets.oci.plaintext["tenancy_ocid"]
  description    = "homestack compartment"
  name           = "homestack"
  enable_delete  = true
}