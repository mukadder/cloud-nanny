# cloud nanny
A simple demo using AWS lamdba and cloudwatch events to start and stop EC2 instances based on cron schedules.

# Installation
```bash
export AWS_PROFILE=<profile>
./create-roles.sh
./deploy.sh
```

Tag instances with `stopAtNight` to start / stop based on WakeUp and BedTime schedule.

Update and rerun `./set-wakeup.sh` and `./set-bedtime.sh` to change scheduling.


# Manual test of the python script

From the command line terminal.
```bash
export AWS_PROFILE=<profile>
python nanny.py    
```

To redeploy the lamdba rerun the `./deploy.sh` script.
