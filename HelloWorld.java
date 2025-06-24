//public class HelloWorld {
// public static void main(String[] args) {
//  System.out.println("Hello, World!");
// }
//}

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class HelloWorld {
    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(80), 0);
        server.createContext("/", new HelloHandler());
        server.setExecutor(null); // creates a default executor
        System.out.println("Server started on port 80");
        server.start();
    }

    static class HelloHandler implements HttpHandler {
        public void handle(HttpExchange exchange) throws IOException {
            String response = "Hello from Java HTTP Server!";
            exchange.sendResponseHeaders(200, response.length());
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        }
    }
}
