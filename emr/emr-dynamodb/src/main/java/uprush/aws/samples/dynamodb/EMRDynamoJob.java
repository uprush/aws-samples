package uprush.aws.samples.dynamodb;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.JobContext;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.NullOutputFormat;

public class EMRDynamoJob {
    public static void main( String[] args ) throws Exception
    {
    	System.out.println("Starting EMR DynamoDB job...");
    	String inputPath = args[0];
    	String accessKey = args[1];
    	String secretKey = args[2];
    	String region = args[3];
    	
    	System.out.println("input path: " + inputPath);
    	System.out.println("access key: " + accessKey);
    	System.out.println("secret key: " + "********");
    	System.out.println("region: " + region);
    	
    	Configuration conf = new Configuration();
    	conf.set("ACCESS_KEY", accessKey);
    	conf.set("SECRET_KEY", secretKey);
    	conf.set("REGION", region);
    	
    	Job job = new Job(conf, "DynamoDB with EMR sample");
    	job.setJarByClass(EMRDynamoJob.class);
    	
    	job.setMapperClass(DDBSample.DDBMapper.class);
    	job.setInputFormatClass(TextInputFormat.class);
    	job.setOutputFormatClass(NullOutputFormat.class);
    	
    	job.setNumReduceTasks(0);
    	
    	FileInputFormat.addInputPath(job, new Path(inputPath));
    	job.waitForCompletion(true);
    }
}
