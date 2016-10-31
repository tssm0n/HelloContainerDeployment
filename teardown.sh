#!/bin/bash

stackname="ecs-test5"

aws --profile gawd --region us-east-1 cloudformation delete-stack --stack-name ${stackname}

status=`aws --profile gawd --region us-east-1 cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[0].StackStatus'`
echo $status
