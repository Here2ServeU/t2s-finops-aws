import boto3
import json
import logging
import os

AWS_REGION = os.getenv("LAMBDA_AWS_REGION")

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client('ec2')
rds = boto3.client('rds')
cloudwatch = boto3.client('cloudwatch')

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")

    # Check underutilized EC2 instances
    instances = get_underutilized_ec2_instances()
    if instances:
        stop_ec2_instances(instances)

    # Check underutilized RDS instances
    rds_instances = get_underutilized_rds_instances()
    if rds_instances:
        stop_rds_instances(rds_instances)

    return {"message": "Cost optimization executed."}

def get_underutilized_ec2_instances():
    response = cloudwatch.get_metric_data(
        MetricDataQueries=[
            {
                'Id': 'low_cpu',
                'MetricStat': {
                    'Metric': {
                        'Namespace': 'AWS/EC2',
                        'MetricName': 'CPUUtilization',
                        'Dimensions': [{'Name': 'InstanceId', 'Value': 'i-*'}]
                    },
                    'Period': 3600,
                    'Stat': 'Average',
                },
                'ReturnData': True
            }
        ],
        StartTime=datetime.utcnow() - timedelta(days=1),
        EndTime=datetime.utcnow()
    )
    underutilized = [metric['Dimensions'][0]['Value'] for metric in response['MetricDataResults'][0]['Values'] if metric < 10]
    return underutilized

def stop_ec2_instances(instance_ids):
    ec2.stop_instances(InstanceIds=instance_ids)
    logger.info(f"Stopped EC2 Instances: {instance_ids}")

def get_underutilized_rds_instances():
    rds_instances = []
    response = rds.describe_db_instances()
    for instance in response['DBInstances']:
        if instance['DBInstanceStatus'] == "available":
            stats = cloudwatch.get_metric_data(
                MetricDataQueries=[{
                    'Id': 'low_conn',
                    'MetricStat': {
                        'Metric': {
                            'Namespace': 'AWS/RDS',
                            'MetricName': 'DatabaseConnections',
                            'Dimensions': [{'Name': 'DBInstanceIdentifier', 'Value': instance['DBInstanceIdentifier']}]
                        },
                        'Period': 3600,
                        'Stat': 'Average',
                    },
                    'ReturnData': True
                }],
                StartTime=datetime.utcnow() - timedelta(days=1),
                EndTime=datetime.utcnow()
            )
            if stats['MetricDataResults'][0]['Values'][0] < 5:
                rds_instances.append(instance['DBInstanceIdentifier'])

    return rds_instances

def stop_rds_instances(db_instances):
    for db in db_instances:
        rds.stop_db_instance(DBInstanceIdentifier=db)
    logger.info(f"Stopped RDS Instances: {db_instances}")