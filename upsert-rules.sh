#!/bin/bash
set -e

# stop at 21:55 and start at 06:00
BEDTIME_RULE_ARN=$(aws events put-rule --name Nanny-BedTime --description "Bedtime signal" --schedule-expression 'cron(55 21 * * ? *)' --query RuleArn --output text)
WAKEUP_RULE_ARN=$(aws events put-rule --name Nanny-WakeUp --description "Wakeup signal" --schedule-expression 'cron(0 6 * * ? *)' --query RuleArn --output text)
