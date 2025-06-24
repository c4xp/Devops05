//public class HelloWorld {
// public static void main(String[] args) {
//  System.out.println("Hello, World!");
// }
//}

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class HelloWorld {
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(80), 0);
        server.createContext("/", new HelloHandler());
        server.setExecutor(null);
        System.out.println("Server started on port 80...");
        server.start();
    }

    static class HelloHandler implements HttpHandler {
        public void handle(HttpExchange t) {
            try {
                String response = "Hello, World!";
                t.sendResponseHeaders(200, response.length());
                OutputStream os = t.getResponseBody();
                os.write(response.getBytes());
                os.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
