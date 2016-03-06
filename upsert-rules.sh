#!/bin/bash
set -e

# stop at 22:59 and start at 06:01
BEDTIME_RULE_ARN=$(aws events put-rule --name Nanny-BedTime --description "Bedtime signal" --schedule-expression 'cron(59 21 * * ? *)' --query RuleArn --output text)
WAKEUP_RULE_ARN=$(aws events put-rule --name Nanny-WakeUp --description "Wakeup signal" --schedule-expression 'cron(1 5 * * ? *)' --query RuleArn --output text)
