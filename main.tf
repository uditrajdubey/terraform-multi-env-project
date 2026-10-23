module "dev-infra" {

  source     = "./custom_infra_aws"
  custom_env = "dev"
  ec2_ami_id = "ami-01a00762f46d584a1" #  Ubuntu(OS) of ap-south-1
  ec2_count  = 2
  ec2_type   = "t3.micro"

}
module "stg-infra" {

  source     = "./custom_infra_aws"
  custom_env = "stg"

  ec2_ami_id = "ami-04394a3a96907e9ec" # Amzon linux(OS) of ap-south-1
  ec2_count  = 1
  ec2_type   = "t3.micro"

}

module "prd-infra" {

  source     = "./custom_infra_aws"
  custom_env = "prd"
  ec2_ami_id = "ami-0011550b539717e2a" # Redhat (OS) of ap-south-1
  ec2_count  = 1
  ec2_type   = "t3.micro"

}
