package uprush.aws.samples.dynamodb;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeDefinition;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.BatchWriteItemRequest;
import com.amazonaws.services.dynamodbv2.model.CreateTableRequest;
import com.amazonaws.services.dynamodbv2.model.CreateTableResult;
import com.amazonaws.services.dynamodbv2.model.DeleteTableRequest;
import com.amazonaws.services.dynamodbv2.model.DeleteTableResult;
import com.amazonaws.services.dynamodbv2.model.KeySchemaElement;
import com.amazonaws.services.dynamodbv2.model.KeyType;
import com.amazonaws.services.dynamodbv2.model.ListTablesResult;
import com.amazonaws.services.dynamodbv2.model.ProvisionedThroughput;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.dynamodbv2.model.PutItemResult;
import com.amazonaws.services.dynamodbv2.model.PutRequest;
import com.amazonaws.services.dynamodbv2.model.ScalarAttributeType;
import com.amazonaws.services.dynamodbv2.model.WriteRequest;

/**
 * Hello world!
 *
 */
public class DDBSample 
{
	String accessKey;
	String secretKey;
	Regions region;
	static final String SAMPLE_TABLE = "mytable";
	int id;
	AmazonDynamoDBClient ddb;
	long wordCount;
	
    public static void main( String[] args )
    {
    }
    
    public DDBSample(String accessKey, String secretKey, Regions region) {
    	this.accessKey = accessKey;
    	this.secretKey = secretKey;
    	this.region = region;

    	id = this.hashCode();
    	ddb = connect();
    }
    
    public AmazonDynamoDBClient connect() {
    	BasicAWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
    	AmazonDynamoDBClient dynamoClient = new AmazonDynamoDBClient(credentials);
    	dynamoClient.setRegion(Region.getRegion(region));
    	return dynamoClient;
    }
    
    public CreateTableResult createSampleTable() {
    	List<KeySchemaElement> keys = new ArrayList();
    	keys.add(new KeySchemaElement().withAttributeName("key").withKeyType(KeyType.HASH));
    	keys.add(new KeySchemaElement().withAttributeName("version").withKeyType(KeyType.RANGE));
    	CreateTableRequest req = new CreateTableRequest(SAMPLE_TABLE, keys);
    	req.setProvisionedThroughput(new ProvisionedThroughput(10L, 10L));
    	
    	List<AttributeDefinition> attrs = new ArrayList();
    	attrs.add(new AttributeDefinition().withAttributeName("key").withAttributeType(ScalarAttributeType.S));
    	attrs.add(new AttributeDefinition().withAttributeName("version").withAttributeType(ScalarAttributeType.S));
    	req.setAttributeDefinitions(attrs);
    	
    	return ddb.createTable(req);
    }
    
    public DeleteTableResult deleteSampleTable() {
    	return ddb.deleteTable(new DeleteTableRequest(SAMPLE_TABLE));
    }
    
    public boolean isSampleTableExist() {
    	ListTablesResult tables = ddb.listTables();
    	return tables.getTableNames().contains(SAMPLE_TABLE);
    }
    
    public void createSampleTableIfNotExist() {
    	if (!isSampleTableExist()) {
    		createSampleTable();    		
    	}
    }
    
    public void populateData() {
    	
    	List<WriteRequest> items = new ArrayList();
    	for (int i = 0; i < 10; i++) {
    		Map<String, AttributeValue> item = new HashMap();
    		item.put("key", new AttributeValue(String.format("photo-%d-%d", id, i)));
    		item.put("version", new AttributeValue(String.format("1234%d", i)));
    		item.put("photographer", new AttributeValue("someone"));
    		
    		PutRequest put = new PutRequest().withItem(item);
    		items.add(new WriteRequest(put));
    	}
    	
    	Map<String, List<WriteRequest>> requestItems = new HashMap();
    	requestItems.put(SAMPLE_TABLE, items);
    	BatchWriteItemRequest req = new BatchWriteItemRequest(requestItems);
    	ddb.batchWriteItem(req);
    }
    
    public PutItemResult putWord(String word) {
		Map<String, AttributeValue> item = new HashMap();
		item.put("key", new AttributeValue(String.format("sample-%d", id)));
		item.put("version", new AttributeValue(String.valueOf(wordCount++)));
		item.put("word", new AttributeValue(word));
    	
		PutItemRequest req = new PutItemRequest(SAMPLE_TABLE, item);
		return ddb.putItem(req);
    }
    
    // ----- EMR with DynamoDB samples -----
    public enum DDBCounters {
    	Puts
    }
    
    public static class DDBMapper extends Mapper<Object, Text, Object, Object> {
    	
    	DDBSample sample;

		@Override
		protected void setup(Context context) throws IOException,
				InterruptedException {
			System.out.println("Setting up DynamoDB client...");
			String accessKey = context.getConfiguration().get("ACCESS_KEY");
			String secretKey = context.getConfiguration().get("SECRET_KEY");
			String region = context.getConfiguration().get("REGION");

	    	System.out.println("[mapper] access key: " + accessKey);
	    	System.out.println("[mapper] secret key: " + "********");
	    	System.out.println("[mapper] region: " + region);

			sample = new DDBSample(accessKey, secretKey, Regions.fromName(region));
			System.out.println("Create DynamoDB table if not exist.");
			sample.createSampleTableIfNotExist();
		}

		@Override
		protected void map(Object key, Text value, Context context)
				throws IOException, InterruptedException {
			StringTokenizer itr = new StringTokenizer(value.toString());
		     while (itr.hasMoreTokens()) {
		       sample.putWord(itr.nextToken());
		       context.getCounter(DDBCounters.Puts).increment(1);
		     }
		}
    	
    }
}
