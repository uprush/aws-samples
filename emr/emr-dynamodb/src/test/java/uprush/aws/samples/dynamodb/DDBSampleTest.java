package uprush.aws.samples.dynamodb;

import static org.junit.Assert.assertTrue;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;

/**
 * Unit test for DDBSample.
 */
@RunWith(JUnit4.class)
public class DDBSampleTest
{

	DDBSample sample;
	static final String ACCESS_KEY = System.getenv("AWS_ACCESS_KEY_ID");
	static final String SECRET_KEY = System.getenv("AWS_SECRET_ACCESS_KEY");
	static final String REGION = System.getenv("AWS_REGION");

	@Before
	public void setup() {
		sample = new DDBSample(ACCESS_KEY, SECRET_KEY, Regions.fromName(REGION));
	}

    @Test
    @Ignore
    public void testConnect()
    {
    	sample.connect();
    	assertTrue(true);
    }

    @Test
    @Ignore
    public void testCreateSampleTable() {
    	if (sample.isSampleTableExist()) {
    		sample.deleteSampleTable();    		
    	}
    	sample.createSampleTable();
    	Assert.assertTrue(sample.isSampleTableExist());
    }
    
    @Test
    @Ignore
    public void testPopulateData() {
    	sample.populateData();
    	// TODO: assert
    }
    
    @Test
    @Ignore
    public void testPutWord() {
    	sample.putWord("hello");
    	sample.putWord("world");
    }
}
