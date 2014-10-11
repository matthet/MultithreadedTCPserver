require "socket"
server = TCPServer.open(2626)
loop do
    Thread.fork(server.accept) do |client| 
        client.puts("Hello", "Goodbye xo")
        client.close
    end
end