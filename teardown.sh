#!/bin/bash

stackname="hello-ecs"

aws "$@" cloudformation delete-stack --stack-name ${stackname}

status=`aws "$@" cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[0].StackStatus'`
echo $status
