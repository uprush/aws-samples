package uprush.aws.samples.elasticache;

import net.spy.memcached.MemcachedClient;

import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import org.junit.Test;
import static org.junit.Assert.*;

@RunWith(JUnit4.class)
public class AutoDiscoveryTest 
{

	@Test
    public void testConnect()
    {
        try {
            String configEndpoint = "auto-discovery-demo.t1wsve.cfg.usw2.cache.amazonaws.com";
            Integer clusterPort = 11211;
            
            AutoDiscovery ad = new AutoDiscovery();
            MemcachedClient client = ad.connect(configEndpoint, clusterPort);

            // Store a data item for an hour.  The client will decide which cache host will store this item. 
            String key, value, got;            
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
