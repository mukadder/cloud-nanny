#!/bin/bash
set -e
# 06:00
aws events put-rule --name Nanny-WakeUp --description "Wakeup signal" --schedule-expression 'cron(0 6 * * ? *)' --query RuleArn --output text
