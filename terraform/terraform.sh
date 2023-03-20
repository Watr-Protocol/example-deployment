#!/bin/bash
# Simple wrapper for Terraform to select the target environment
# Usage: terraform.sh $ENV [plan/apply/...]
set -e

ENVIRONMENT=$1
export TF_WORKSPACE=${ENVIRONMENT}

case "${ENVIRONMENT}" in
region1-test)
	export TF_VAR_terraform_state_bucket=test-watr
	export TF_VAR_aws_region=eu-north-1
	export TF_VAR_environment=region1-test
	;;
*)
	echo "Environment: ${ENVIRONMENT} not recognized"
	;;
esac

export TF_CLI_ARGS_init=" \
     -backend-config bucket=${TF_VAR_terraform_state_bucket} \
     -backend-config region=${TF_VAR_aws_region} \
     -backend-config key=terraform.tfstate"

# shellcheck disable=SC2086
if ! [[ $2 == "show" ]] && ! [[ $2 == "untaint" ]] && ! [[ $2 == "state" ]] && ! [[ $2 == "force-unlock" ]]; then
	TF_CLI_ARGS="-var-file=$(dirname $0)/${ENVIRONMENT}.tfvars"
	export TF_CLI_ARGS
fi

# Execute terraform and pass the remaining command line parameters
terraform "${@:2}"
