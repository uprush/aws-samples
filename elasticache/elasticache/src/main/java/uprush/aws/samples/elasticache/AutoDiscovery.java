package uprush.aws.samples.elasticache;

import java.io.IOException;
import java.net.InetSocketAddress;

import net.spy.memcached.MemcachedClient;

/**
 * Hello world!
 *
 */
public class AutoDiscovery 
{

    public MemcachedClient connect(String endpoint, int port) throws IOException {
        // The client will connect to the other cache nodes automatically
    	return new MemcachedClient(new InetSocketAddress(endpoint, port));
    }
}
