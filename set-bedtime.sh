#!/bin/bash
set -e
# 21:55
aws events put-rule --name Nanny-BedTime --description "Bedtime signal" --schedule-expression 'cron(55 21 * * ? *)' --query RuleArn --output text
