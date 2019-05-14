# **Private Terraform Enterprise Installation**

## **PTFE Data Location**
https://www.terraform.io/docs/enterprise/private/reliability-availability.html#installer-architecture

|Data Location|Configuration|Vault|PostgreSQL|Blob Storage|
|:---:|:---|:---|:---|:---|
|Demo	|Stored in Docker volumes on instance	|Key material is stored in Docker volumes on instance, storage backend is internal PostgreSQL	|Stored in Docker volumes on instance	|Stored in Docker volumes on instance
|Mounted Disk	|Stored in Docker volumes on instance	|Key material on host in /var/lib/tfe-vault, storage backend is mounted disk PostgreSQL	|Stored in mounted disks	|Stored in mounted disks
|External Vault	|-	|Key material in external Vault with user-defined storage backend	|-	|-
|**External Services**	|Stored in Docker volumes on instance	|Key material on host in /var/lib/tfe-vault, storage backend is external PostgreSQL	|Stored in external service	|Stored in external service



[추가 Link]
- Terraform vault code: https://github.com/hashicorp/terraform-aws-vault.git
- Terraform docs: https://github.com/hashicorp/terraform-enterprise-modules/tree/master/docs

## **PTFE CODE** 
전체(Demo/MountedDisk/External): https://github.com/hashicorp/private-terraform-enterprise<br>
External: https://github.com/jiyeonkkk/ptfe_external.git 


External Services 설치를 위해 EC2, RDS(internal vault) 진행

**1. main.tf**
   
       - randome pet : password random generation
       - module : network
       - module : pes (external)
       >> output : random password (rds,replicated에서 참조)

**2. module (network,pes)**
    
    1. network
       - vpc
       - internet gateway
       - route table
       - subnet
       - db subnet group
       - route table association
       - sercurity group
          > LB, Auto scailing group, launch configuration 추가 필요
    2. pes
       - instance
          > 1대 생성 (공식 코드는 2대)
       - eip
       - route53 record
       - s3 bucket
       - rds(db instance)
          > multi-az 설정 (공식 코드는 single)
       - iam role
       - iam instance profile
       - iam role policy


**3. user-data.tpl**

   https://www.terraform.io/docs/enterprise/private/automating-the-installer.html#application-settings 
       
       >> replicated 설정
       - /etc/replicated.conf
         . install.sh 수행 시 참조
         . DaemonAuthenticationPassword : random output
         . LicenseFileLocation : license path
       - /tmp/replicated-settings.json
         . installation_type : production (아닌경우 poc)
         . production_type : external (아닌경우 Disk)
         . pg_user : rds user
         . pg_password : random output
         . pg_netloc : rds-endpoint:port
         . pg_dbname : rds db

## **TFE Install 스크립트 수행 전 (필수)**
https://www.terraform.io/docs/enterprise/private/preflight-installer.html#postgresql-requirements
- **Terraform apply**

- **RDS 내 수행**
    > psql -h postgre-endpoint -U postgre-user

        CREATE SCHEMA rails; 
        CREATE SCHEMA vault; 
        CREATE SCHEMA registry; 

- **Instance에서 수행**
    > root 계정에서 수행

        curl https://install.terraform.io/ptfe/stable> /home/ubuntu/install.sh
        bash /home/ubuntu/install.sh no-proxy
