require "socket"

message = ARGV[0]

port = 2631
host_ip = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

s = TCPSocket.open(host_ip, port)
s.puts(message)

while line = s.gets
    puts "received : #{line.chop}"
end

s.close
