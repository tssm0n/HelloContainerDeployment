#!/bin/bash

stackname="ecs-test5"

aws --profile gawd --region us-east-1 cloudformation create-stack --stack-name ${stackname} --capabilities CAPABILITY_IAM --template-body file://ecs.yml --parameters  ParameterKey=KeyName,ParameterValue=kms ParameterKey=SubnetID,ParameterValue=subnet-03f9222e ParameterKey=VPCID,ParameterValue=vpc-6d86960a

status=`aws --profile gawd --region us-east-1 cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[0].StackStatus'`
echo $status

while [  $status == "\"CREATE_IN_PROGRESS\"" ]; do
  sleep 20s
  status=`aws --profile gawd --region us-east-1 cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[0].StackStatus'`
  echo $status
done

url=`aws --profile gawd --region us-east-1 cloudformation describe-stacks --stack-name ${stackname} --query "Stacks[0].Outputs[?OutputKey=='dnsname'].OutputValue" --output text`
echo "http://$url:5000"

