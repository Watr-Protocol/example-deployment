# watr example deployment guide

## Requirements

- `terrafom` version 1.0.3
- Terraform setup with your aws access key (`aws_access_key_id` and `aws_secret_access_key`)

## Terraform initial deployment

1. `cd terraform/01_infrastructure`
2. Create an s3 bucket, in your aws region i.e.

   `aws s3api create-bucket --bucket test-watr --region eu-north-1 --create-bucket-configuration LocationConstraint=eu-north-1`

3. Edit the `../terraform.sh` file with an entry for each region, and add your bucket name in `TF_VAR_terraform_state_bucket` variable's value e.g.:

   ```bash
   case "$ENVIRONMENT" in
     region1-test)
       export TF_VAR_terraform_state_bucket=test-watr
       export TF_VAR_aws_region=us-east-1
       export TF_VAR_environment=region1-test
       ;;
     *)
       echo "Environment: $ENVIRONMENT not recognized"
       ;;
   esac
   ```

4. Initalize the s3 bucket and install terraform modules, e.g. for region1-test:

   `../terraform.sh region1-test init -var-file=../region1-test.tfvars`

5. Run a terraform plan to see a list of objects to be created:

   `../terraform.sh region1-test plan -var-file=../region1-test.tfvars`

6. Apply this configuration to deploy the vpc, hosts etc...:

   `../terraform.sh region1-test apply -var-file=../region1-test.tfvars`

7. Answer "yes", wait until it finishes and review your created instances

### Terraform infrastructure update

Change terraform configs and re-run from step #5.

## Ansible initial deployment

Once the hosts have been deployed ansible is used to configure the base system and install the parachain binary and configuration.

An example ansible inventory file (`inventory.yml`) in the ansible folder. Edit this to contain the correct ip address or dns name of each host.

The `node` ansible-galaxy role comes from a paritytech ansible collections repo. To install run the command from the ansible folder:

1. `cd ../ansible`

2. Install ansible collections:

   `mkdir collections && ansible-galaxy install -f -r requirements.yml -p ./collections`

3. Run base setup on all hosts:

   `ansible-playbook -i inventory.yml -u admin base.yml`

4. Setup monitoring host (optional) for grafana, prometheus etc..:

   `ansible-playbook -i inventory.yml -u admin monitoring.yml --check --diff`

   This will show all changes, if this looks good go ahead and apply it:

   `ansible-playbook -i inventory.yml -u admin monitoring.yml`

   Don't forget changing a default Grafana password after this is successfully applied for the first time.
   Also, it might be required to setup DNS records for the new monitoring domain.

5. Install parachain binary and configuration:

   `ansible-playbook -i inventory.yml -u admin node.yml`

### Ansible deployment update

To update e.g. parachain binary / spec / configuration

1. edit the `ansible/inventory.yml` file
2. re-run step #4 with `--check --diff` flags, see if it looks good
3. re-run step #4 to apply the changes
