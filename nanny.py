import boto3

def toggle_instance(instance, start):
    ec2 = boto3.resource("ec2", region_name="us-east-1")
    instance = ec2.Instance(instance["InstanceId"])
    if start:
        instance.start()
    else:
        instance.stop()
    
def toggle_instances(start):
    ec2_client = boto3.client("ec2", region_name="us-east-1")
    action_name = 'start' if start else 'stop'
    print('Looking for instances to {}'.format(action_name))
    # Look for the tag stopAtNight
    description = ec2_client.describe_instances( Filters=[ { 'Name': 'instance-state-name', 
        'Values': ['stopped' if start else 'running'] },
        { 'Name': 'tag-key', 'Values' : ['stopAtNight'] }])
    
    for reservation in description["Reservations"]:
        for instance in reservation["Instances"]:
            print('instance to {}: {}'.format(action_name, instance["InstanceId"]))
            toggle_instance(instance, start)

        
def lambda_handler(event, context):
    print event
    toggle_instances("WakeUp" in event["resources"][0])

def main():
    # For local testing
    event = { "resources" : ["arn:aws:events:us-east-1:1234567899876:rule/Nanny-BedTime"] }
    lambda_handler(event, None)

if __name__ == "__main__":
    main()
