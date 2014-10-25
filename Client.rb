require "socket"

message = ARGV[0]

hostname = 'macneill'
s = TCPSocket.open(hostname, 2631)
s.puts(message)

while line = s.gets
    puts "received : #{line.chop}"
end

s.close
