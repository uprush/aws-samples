#!/bin/bash

cd /home/hadoop/lib
rm -f aws-java-sdk-*.jar
rm -f httpcore-4.1.jar
rm -f httpclient-4.1.1.jar
wget --no-check-certificate https://s3-us-west-2.amazonaws.com/yifeng-public/download/aws-java-sdk-1.6.5.jar
wget --no-check-certificate https://s3-us-west-2.amazonaws.com/yifeng-public/download/httpcore-4.2.jar
wget --no-check-certificate https://s3-us-west-2.amazonaws.com/yifeng-public/download/httpclient-4.2.jar
