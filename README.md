# watr example deployment guide

Requirements:
- Terraform setup with your aws access key (`aws_access_key_id` and `aws_secret_access_key`)
- An S3 bucket to store terraform state information (use this name in the terraform.sh file)

## Terraform

1. `cd terraform/01_infrastructure`

2. Create an s3 bucket, e.g. `test-region1-tfstate-00001`

3. Edit the `../terraform.sh` file with an entry for each region, e.g.:

  ```
  case "$ENVIRONMENT" in
     test-region1)
       export TF_VAR_terraform_state_bucket=test-region1-tfstate-00001
       export TF_VAR_aws_region=us-east-1
       export TF_VAR_environment=test-region1
       ;;
     *)
       echo "Environment: $ENVIRONMENT not recognized"
       ;;
   esac
   ```

3. Initalize the s3 bucket and install terraform modules, e.g. for test-region1:

   `../terraform.sh test-region1 init -var-file=../test-region1.tfvars`


6. Run a terraform plan to see a list of objects to be created:

  `../terraform.sh test-region1 plan -var-file==../test-region1.tfvars`

8. Apply this configuration to deploy the vpc, hosts etc...:
  `../terraform.sh test-region1 apply -var-file=../test-region1.tfvars`

## Ansible

Once the hosts have been deployed ansible is used to configure the base system and install the parachain binary and configuration.

An example ansible inventory file (`test-region1.yaml`) in the ansible folder. Edit this to contain the correct ip address or dns name of each host.

The `node` ansible-galaxy role comes from a paritytech ansible collections repo. To install run the command from the ansible folder:

1. Install ansible collections:

`mkdir collections && ansible-galaxy collection install -f -r requirements.yml -p ./collections


2. Run base setup on all hosts:

   `ansible-playbook -i test-region1.yaml base.yaml --check --diff`

    This will show all changes, if this looks good go ahead and apply it:

   `ansible-playbook -i test-region1.yaml base.yaml`

3. Setup monitoring host (optional) for grafana, prometheus etc..:

     `ansible-playbook -i test-region1.yaml monitoring.yaml --check --diff`

    This will show all changes, if this looks good go ahead and apply it:

   `ansible-playbook -i test-region1.yaml base.yaml`

4. Install parachain binary and configuration:

   `ansible-playbook -i test-region1.yaml node.yaml --check --diff`

   This will show all changes, if this looks good go ahead and apply it:

    `ansible-playbook -i test-region1.yaml node.yaml`
   
To run updates on the parachain binary / spec / configuration, edit the inventory file and re-run step #4.
