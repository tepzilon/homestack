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
    cloudflare = {
      source  = "hashicorp/cloudflare"
      version = "5.1.0"
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

provider "cloudflare" {
  api_token = data.aws_kms_secrets.cloudflare.plaintext["api_token"]
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

data "aws_kms_secrets" "cloudflare" {
  secret {
    name    = "api_token"
    payload = "AQICAHhdhDx+mvb065S66mmsEOw5VGksyFAQFNIgM/njoXpYDwHHv76BjkNx+P3vEXuMxypDAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDL0nJGlXBt/mUBhW6wIBEIBDQ1TFEQCqc7CTjm4LgQylFGZV5Qg+9+DIekEp1MCXvAMM0NnKRAF49wFEsQYFGWxgzpeoewlwrcOPlwNn95SkkS3YfQ=="
    key_id  = var.kms_key_id
  }
  secret {
    name    = "zone_id"
    payload = "AQICAHhdhDx+mvb065S66mmsEOw5VGksyFAQFNIgM/njoXpYDwGrtWG2g1QYGoV7XxAp74WiAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMsNLVulbFKJsRTVhLAgEQgDtto+UdMLab2ymOW1/gibQ30IsOdii/vqt1trCSTcYrQ8yb69qDZDfsiir+8OJJ1Z+FEpZI00SOJvVGog=="
    key_id  = var.kms_key_id
  }
}

data "aws_kms_secrets" "exit_node" {
  secret {
    name    = "public_ssh_key"
    payload = "AQICAHhdhDx+mvb065S66mmsEOw5VGksyFAQFNIgM/njoXpYDwHiunTsghtGp7OBHVAJkqvWAAAA1zCB1AYJKoZIhvcNAQcGoIHGMIHDAgEAMIG9BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDI6HlyKL/QLFN9FfqwIBEICBj/AqqWvn7HxAfMH0Uw6rN2SozGo+2yJ4H2cNI0YyjOVQJK6ZcTwAJPzuzKxHlWOiujxQiZTeMQhDvcEbqQeHopPzxgvbbLMwQrX1RFoNPlxXqpns7xf6yijyyZkIx+rjhNoY4nXLtBSrEIfkeNGV51mFaIp5xAKzHhxhqLG8r3M9sGJqMA8a8ozxin42lI5Y"
    key_id  = var.kms_key_id
  }
}

// identity compartment
resource "oci_identity_compartment" "homestack_ic" {
  compartment_id = data.aws_kms_secrets.oci.plaintext["tenancy_ocid"]
  description    = "homestack compartment"
  name           = "homestack"
  enable_delete  = true
}

// virtual cloud network
resource "oci_core_vcn" "homestack_vcn" {
  compartment_id = oci_identity_compartment.homestack_ic.compartment_id
  cidr_block     = "10.0.0.0/16"
  display_name   = "homestack-vcn"
  dns_label      = "homenetwork"
}

// internet gateway
resource "oci_core_internet_gateway" "homestack_igw" {
  compartment_id = oci_identity_compartment.homestack_ic.compartment_id
  vcn_id         = oci_core_vcn.homestack_vcn.id
  enabled        = true
  display_name   = "homestack-igw"
}

// route table
resource "oci_core_route_table" "homestack_route_table" {
  compartment_id = oci_identity_compartment.homestack_ic.compartment_id
  vcn_id         = oci_core_vcn.homestack_vcn.id
  display_name   = "homestack-route-table"
  route_rules {
    network_entity_id = oci_core_internet_gateway.homestack_igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

// security list
resource "oci_core_security_list" "homestack_security_list" {
  compartment_id = oci_identity_compartment.homestack_ic.compartment_id
  vcn_id         = oci_core_vcn.homestack_vcn.id
  display_name   = "homestack-security-list"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    destination_type = "CIDR_BLOCK"
    stateless        = false
  }
  ingress_security_rules {
    protocol    = 6 // TCP
    source      = "0.0.0.0/0"
    description = "SSH from anywhere"
    tcp_options {
      min = 22
      max = 22
    }
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    protocol    = 1 // ICMP
    source      = "0.0.0.0/0"
    description = "ICMP from anywhere"
    icmp_options {
      type = 8 // echo
    }
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    protocol    = 6 // TCP
    source      = "0.0.0.0/0"
    description = "Portainer from anywhere"
    tcp_options {
      min = 9443
      max = 9443
    }
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    protocol    = 6 // TCP
    source      = "0.0.0.0/0"
    description = "HTTP from anywhere"
    tcp_options {
      min = 80
      max = 80
    }
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    protocol    = 6 // TCP
    source      = "0.0.0.0/0"
    description = "HTTPS from anywhere"
    tcp_options {
      min = 443
      max = 443
    }
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
}

// public subnet
resource "oci_core_subnet" "homestack_public_subnet" {
  cidr_block                 = "10.0.0.0/24"
  compartment_id             = oci_identity_compartment.homestack_ic.compartment_id
  vcn_id                     = oci_core_vcn.homestack_vcn.id
  display_name               = "homestack-public-subnet"
  dns_label                  = "publicsubnet"
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.homestack_route_table.id
  security_list_ids          = [oci_core_security_list.homestack_security_list.id]
}

// availability domain
data "oci_identity_availability_domain" "homestack_ad" {
  compartment_id = oci_identity_compartment.homestack_ic.compartment_id
  ad_number      = 1
}

// exit node instance
resource "oci_core_instance" "homestack_exit_node" {
  availability_domain = data.oci_identity_availability_domain.homestack_ad.name
  compartment_id      = oci_identity_compartment.homestack_ic.compartment_id
  shape               = "VM.Standard.A1.Flex"
  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    display_name              = "homestack-exit-node-vnic"
    subnet_id                 = oci_core_subnet.homestack_public_subnet.id
  }
  metadata = {
    ssh_authorized_keys = data.aws_kms_secrets.exit_node.plaintext["public_ssh_key"]
  }
  source_details {
    source_type = "image"
    # Canonical-Ubuntu-24.04-aarch64-2024.10.09-0
    # see: https://docs.oracle.com/en-us/iaas/images/ubuntu-2404/canonical-ubuntu-24-04-aarch64-2024-10-09-0.htm
    source_id = "ocid1.image.oc1.ap-singapore-1.aaaaaaaasfd4dtdnlhdzmhourzf5xvejewlubymjbqvph54xcekmlrk6pw7q"
  }
  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }
  display_name = "homestack-exit-node"
}

resource "cloudflare_dns_record" "homestack_exit_node_dns_record" {
  name    = "home"
  type    = "A"
  zone_id = data.aws_kms_secrets.cloudflare.plaintext["zone_id"]
  content = oci_core_instance.homestack_exit_node.public_ip
  ttl     = 1
}
