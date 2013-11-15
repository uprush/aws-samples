DynamoDB Samples
================

Run EMR DynamoDB sample

    ./elastic-mapreduce -j j-35TR9XC5CPC5C --jar s3://yifeng-public/download/dynamodb-0.0.1-SNAPSHOT.jar --args "s3://yifeng-public/text,<access_key>,<secret_key>,<region>"

Error: java.lang.ClassNotFoundException: com.amazonaws.regions.Regions
  at java.net.URLClassLoader$1.run(URLClassLoader.java:366)
  at java.net.URLClassLoader$1.run(URLClassLoader.java:355)
  at java.security.AccessController.doPrivileged(Native Method)
  at java.net.URLClassLoader.findClass(URLClassLoader.java:354)
  at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
  at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:308)
  at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
  at uprush.aws.samples.dynamodb.DDBSample$DDBMapper.setup(DDBSample.java:145)
  at org.apache.hadoop.mapreduce.Mapper.run(Mapper.java:142)
  at org.apache.hadoop.mapred.MapTask.runNewMapper(MapTask.java:771)
  at org.apache.hadoop.mapred.MapTask.run(MapTask.java:375)
  at org.apache.hadoop.mapred.Child$4.run(Child.java:255)
  at java.security.AccessController.doPrivileged(Native Method)
  at javax.security.auth.Subject.doAs(Subject.java:415)
  at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1132)
  at org.apache.hadoop.mapred.Child.main(Child.java:249)