DynamoDB Samples
================

## Build

    mvn clean package

## aws-java-sdk version issue

Make sure you have same aws-java-sdk for dev and on EMR. Log in into the EMR master node, check aws-java-sdk version under `/home/hadoop/lib`.
You will need to use the same version as EMR. Or replace the aws-java-sdk shipped with EMR to your version on EMR bootstrap. Check `./emr-bootstrap.sh` for details.

## Run EMR DynamoDB sample

    ./elastic-mapreduce -j <job_flow> --jar s3://yifeng-public/download/dynamodb-0.0.1-SNAPSHOT.jar --args "s3://yifeng-public/text,<access_key>,<secret_key>,<region>"
