import java.io.*;
import java.net.*;

class Client{

   public static void main(String argv[]) throws Exception {

      System.out.println('\n' + "Type a Word: ");
      BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));
      String word = inFromUser.readLine();
      System.out.println();

      String path = "GET /echo.php?message=" + word + " HTTP/1.0\r\n";

      Socket clientSocket = new Socket("localhost",8888);
      PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);
      out.println(path);

      BufferedReader in = new BufferedReader( new InputStreamReader(clientSocket.getInputStream()));

      String fromServer;
      while((fromServer = in.readLine()) != null){
         System.out.println(fromServer);
      }
   }
}

