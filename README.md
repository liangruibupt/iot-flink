# iot-flink

[Offical guide](https://aws.amazon.com/blogs/big-data/build-a-real-time-stream-processing-pipeline-with-apache-flink-on-aws/)

# CF outputs
| Resource  | Description |
| :-------- | :----------  |
|EmrMasterNode | ssh -C -D 8157 hadoop@{hadoop-master} |
|KibanaDashboardURL | https://{es-domain}/_plugin/kibana/app/kibana#/dashboard/Taxi-Trips-Dashboard |
|ProducerCommand | java -jar kinesis-taxi-stream-producer-1.3.jar -stream flink-refarch-infrastructure-KinesisStream-L31NIRV9SU4B -region us-east-1 -speedup 6480 |
|StartFlinkDemon  | flink-yarn-session -n 2 -s 2 -jm 768 -tm 1024 -d |
|FlinkCommand | flink run -p 4 flink-taxi-stream-processor-1.3.jar --region us-east-1 --stream flink-refarch-infrastructure-KinesisStream-{dummy} --es-endpoint https://{es-domain} --checkpoint s3://flink-refarch-infrastructure-flinkdatabucket-{dummy}/checkpoint-data |
|ProducerInstance | ssh -C ec2-user@{producer-domain} |
|ArtifactBucket | flink-refarch-build-artifacts-artifactbucket-{dummy}.s3.amazonaws.com  
|FlinkApplicationCopyCommand | aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-{dummy}/artifacts/flink-taxi-stream-processor-1.3.jar .  |
|KinesisTaxiTripProducerCopyCommand | aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-{dummy}/artifacts/kinesis-taxi-stream-producer-1.3.jar .|


# Starting the Flink runtime and submitting a Flink program
## connect to ProducerInstance
```bash
ssh-add -K ~/.ssh/{key-pair}.pem
ssh -A ec2-user@{jump-box}
ssh -C -D 8157 hadoop@{hadoop-master} 
```

## start a long-running Flink cluster with two task managers and two slots per task manager:
```bash
flink-yarn-session -n 2 -s 2 -jm 768 -tm 1024 -d
```

## taxi stream processor program start the real-time analysis on flink to analysis of the trip events in the Amazon Kinesis stream.
### FlinkApplicationCopyCommand
```bash
aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-{dummy}/artifacts/flink-taxi-stream-processor-1.3.jar .
```
### FlinkCommand
```bash
flink run -p 4 flink-taxi-stream-processor-1.3.jar --region us-east-1 --stream flink-refarch-infrastructure-KinesisStream-{dummy} --es-endpoint https://{es-domain} --checkpoint s3://flink-refarch-infrastructure-flinkdatabucket-{dummy}/checkpoint-data
```

### Flink URL
https://docs.aws.amazon.com/emr/latest/ReleaseGuide/flink-web-interface.html

### Ingesting trip events into the Amazon Kinesis stream
```bash
aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-{dummy}/artifacts/kinesis-taxi-stream-producer-1.3.jar .
java -jar kinesis-taxi-stream-producer-1.3.jar -stream flink-refarch-infrastructure-KinesisStream-{dummy} -region us-east-1 -speedup 6480
```

### ES URL
```
https://{es-domain}/_plugin/kibana/app/kibana#/dashboard/Taxi-Trips-Dashboard
```