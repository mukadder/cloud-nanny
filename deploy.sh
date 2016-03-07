#!/bin/bash
set -ex

DIR=$(dirname "$0")
EXEC_ROLE_NAME=CloudNannyExection

TIMEOUT=30
MEMORY=128
FUNCTIONNAME=CloudNanny

function_exists() {
  echo "Checking for function $FUNCTIONNAME"
  aws lambda get-function --function-name $FUNCTIONNAME > /dev/null 2>&1
}

zip_package() {
    rm nanny.zip || true; zip -r nanny.zip nanny.py
}

target_lamdba() {
  aws lambda add-permission --function-name $FUNCTIONNAME --statement-id CloudNannyInvoke-$1  --action "lambda:InvokeFunction" \
    --principal events.amazonaws.com --source-arn $2
  aws events put-targets --rule $1 --targets '{"Id":"1", "Arn":"'${FUNCTION_ARN}'"}'
}

create_function() {
  EXEC_ROLE_ARN=$(aws iam get-role --role-name $EXEC_ROLE_NAME --query Role.Arn  --output text)
  FUNCTION_ARN=$(aws lambda create-function --zip-file fileb://nanny.zip --function-name $FUNCTIONNAME \
    --handler nanny.lambda_handler --runtime python2.7 --timeout $TIMEOUT --memory-size $MEMORY \
    --role "$EXEC_ROLE_ARN" --query FunctionArn --output text)

  target_lamdba Nanny-BedTime $($DIR/set-bedtime.sh)
  target_lamdba Nanny-WakeUp $($DIR/set-wakeup.sh)
}

update_function() {
  aws lambda update-function-code --function-name $FUNCTIONNAME --zip-file fileb://nanny.zip
}

# main
zip_package

if function_exists; then
  update_function
else
  create_function
fi