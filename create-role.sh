#!/bin/bash
set -e

EXEC_ROLE_NAME=CloudNannyExection

cat << EOF >  /tmp/trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

cat << EOF >  /tmp/cloudnanny-policy.json
{
   "Version": "2012-10-17",
   "Statement": [
     {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:StopInstances",
        "ec2:StartInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
   ]
}
EOF

create_execution_role() {
  ROLE_ARN=$(aws iam create-role --role-name $EXEC_ROLE_NAME --assume-role-policy-document file:///tmp/trust-policy.json  --query Role.Arn  --output text)
  aws iam put-role-policy --role-name $EXEC_ROLE_NAME --policy-name CloudNannyPolicy --policy-document file:///tmp/cloudnanny-policy.json
  echo $ROLE_ARN
}

create_execution_role