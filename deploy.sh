#!/bin/bash

stackname="hello-ecs"

if [[ $# -eq 0 ]] ; then
    echo 'Arguments: --vpc <aws-vpc-id> --subnet <aws-subnet-id> --key <aws-ec2-key> [<aws-cli-args>]'
    exit 0
fi

cliargs=""

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --subnet)
    subnet="$2"
    shift
    ;;
    --key)
    ec2key="$2"
    shift
    ;;
    --vpc)
    vpc="$2"
    shift
    ;;
    *)
    cliargs="$cliargs$key "
    ;;
esac
shift
done

aws ${cliargs} cloudformation create-stack --stack-name ${stackname} --capabilities CAPABILITY_IAM --template-body file://ecs.yml --parameters  ParameterKey=KeyName,ParameterValue=${ec2key} ParameterKey=SubnetID,ParameterValue=${subnet} ParameterKey=VPCID,ParameterValue=${vpc}

status=`aws ${cliargs} cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[0].StackStatus'`
echo $status

while [  $status == "\"CREATE_IN_PROGRESS\"" ]; do
  sleep 20s
  status=`aws ${cliargs} cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[0].StackStatus'`
  echo $status
done

url=`aws ${cliargs} cloudformation describe-stacks --stack-name ${stackname} --query "Stacks[0].Outputs[?OutputKey=='dnsname'].OutputValue" --output text`
echo "http://$url:5000"

