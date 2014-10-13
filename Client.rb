require "socket"

message = ARGV[0]

s = TCPSocket.open("localhost", 2626)
s.puts(message)

while line = s.gets
    puts "received : #{line.chop}"
end

s.close