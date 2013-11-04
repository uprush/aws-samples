package uprush.aws.samples.elasticache;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import net.spy.memcached.MemcachedClient;

/**
 * Unit test for simple App.
 */
public class AutoDiscoveryTest 
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public AutoDiscoveryTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( AutoDiscoveryTest.class );
    }

    /**
     * Rigourous Test :-)
     */
    public void testConnect()
    {
        try {
            String configEndpoint = "auto-discovery-demo.t1wsve.cfg.usw2.cache.amazonaws.com";
            Integer clusterPort = 11211;
            
            AutoDiscovery ad = new AutoDiscovery();
            MemcachedClient client = ad.connect(configEndpoint, clusterPort);

            // Store a data item for an hour.  The client will decide which cache host will store this item. 
            String key = "theKey";
            String value = "This is the data value";
            client.set(key, 3600, value);
            String got = client.get(key).toString();
            
            assertEquals(value, got);
            
            // more cases
            for (int i = 0; i < 1000; i++) {
            	key = String.format("foo%d", i);
            	value = String.format("bar%d", i);
            	client.set(key, 3600, value);
            	got = client.get(key).toString();
            	assertEquals(value, got);
            }
            
      } catch (Exception e) {
        e.printStackTrace();
        fail("Something is wrong!");
      }
    }
}
