https://aws.amazon.com/blogs/big-data/build-a-real-time-stream-processing-pipeline-with-apache-flink-on-aws/

# CF outputs
EmrMasterNode   ssh -C -D 8157 hadoop@ec2-3-81-234-206.compute-1.amazonaws.com
KibanaDashboardURL  https://search-flink-r-elasti-1u66oq5c659jv-zdgkqzz6npv6fivs4yohgjrw7y.us-east-1.es.amazonaws.com/_plugin/kibana/app/kibana#/dashboard/Taxi-Trips-Dashboard 
ProducerCommand     java -jar kinesis-taxi-stream-producer-1.3.jar -stream flink-refarch-infrastructure-KinesisStream-L31NIRV9SU4B -region us-east-1 -speedup 6480   
StartFlinkDemon     flink-yarn-session -n 2 -s 2 -jm 768 -tm 1024 -d 
FlinkCommand    flink run -p 4 flink-taxi-stream-processor-1.3.jar --region us-east-1 --stream flink-refarch-infrastructure-KinesisStream-L31NIRV9SU4B --es-endpoint https://search-flink-r-elasti-1u66oq5c659jv-zdgkqzz6npv6fivs4yohgjrw7y.us-east-1.es.amazonaws.com --checkpoint s3://flink-refarch-infrastructure-flinkdatabucket-1diog6cqo64xg/checkpoint-data     
ProducerInstance    ssh -C ec2-user@ec2-3-210-54-198.compute-1.amazonaws.com    

ArtifactBucket  flink-refarch-build-artifacts-artifactbucket-kti3rb4exa5m.s3.amazonaws.com  
FlinkApplicationCopyCommand     aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-kti3rb4exa5m/artifacts/flink-taxi-stream-processor-1.3.jar .  
KinesisTaxiTripProducerCopyCommand  aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-kti3rb4exa5m/artifacts/kinesis-taxi-stream-producer-1.3.jar .   

# Starting the Flink runtime and submitting a Flink program
## connect to ProducerInstance
acbc32c1fee9:Downloads ruiliang$ ssh-add -K ~/.ssh/ruiliang-lab-key-pair-us-east1.pem
Identity added: /Users/ruiliang/.ssh/ruiliang-lab-key-pair-cn-northwest1.pem (/Users/ruiliang/.ssh/ruiliang-lab-key-pair-cn-northwest1.pem)
acbc32c1fee9:Downloads ruiliang$ ssh-add -L

ssh -A ec2-user@ec2-3-210-54-198.compute-1.amazonaws.com
ssh -C -D 8157 hadoop@ec2-3-81-234-206.compute-1.amazonaws.com

## start a long-running Flink cluster with two task managers and two slots per task manager:
flink-yarn-session -n 2 -s 2 -jm 768 -tm 1024 -d

## taxi stream processor program start the real-time analysis on flink to analysis of the trip events in the Amazon Kinesis stream.
### FlinkApplicationCopyCommand
aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-kti3rb4exa5m/artifacts/flink-taxi-stream-processor-1.3.jar .
### FlinkCommand
flink run -p 4 flink-taxi-stream-processor-1.3.jar --region us-east-1 --stream flink-refarch-infrastructure-KinesisStream-L31NIRV9SU4B --es-endpoint https://search-flink-r-elasti-1u66oq5c659jv-zdgkqzz6npv6fivs4yohgjrw7y.us-east-1.es.amazonaws.com --checkpoint s3://flink-refarch-infrastructure-flinkdatabucket-1diog6cqo64xg/checkpoint-data

### Flink URL


### Ingesting trip events into the Amazon Kinesis stream
aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-kti3rb4exa5m/artifacts/kinesis-taxi-stream-producer-1.3.jar .
java -jar kinesis-taxi-stream-producer-1.3.jar -stream flink-refarch-infrastructure-KinesisStream-L31NIRV9SU4B -region us-east-1 -speedup 6480

### ES URL
ec2-18-215-233-132.compute-1.amazonaws.com
76GaIimpXQIK.HR;C2@Fm-PZ@*!sSg%x
https://search-flink-r-elasti-1u66oq5c659jv-zdgkqzz6npv6fivs4yohgjrw7y.us-east-1.es.amazonaws.com/_plugin/kibana/app/kibana#/dashboard/Taxi-Trips-Dashboard 