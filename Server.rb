require 'thread'
require "socket"

class Pool

  def initialize(size)
    @size = size
    @jobs = Queue.new
    
    @pool = Array.new(@size) do |i|
      Thread.new do
        Thread.current[:id] = i

        catch(:exit) do
          loop do
            job, args = @jobs.pop
            job.call(*args)
          end
        end
      end
    end
  end
  
  # ### Work scheduling  
  # To schedule a piece of work to be done is to say to the `Pool` that you
  # want something done.
  def schedule(*args, &block)
    @jobs << [block, args]
  end
  
  def shutdown
    @size.times do
      schedule { throw :exit }
    end
    @pool.map(&:join)
  end
end

if $0 == __FILE__
  port = 2631
  host_ip = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address

  server = TCPServer.new(host_ip, port)
  p = Pool.new(10)

  loop do
    p.schedule(server.accept) do |client|
      message = client.gets
      if message[0..3] == "HELO"
          client.puts"#{message}IP:#{host_ip}\nPort:#{port}\nStudentID:11374331"
          client.close
        elsif message == "KILL_SERVICE\n"
          client.puts("Service Killed")
          client.close
          server.close
        else
          client.puts("Aw you put your own message! I'm just going to say Hey! Bye..")
          client.close
      end
    end
  end
  server.close
  at_exit { p.shutdown }
end


