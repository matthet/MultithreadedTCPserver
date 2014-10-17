require 'thread'
require "socket"

class Pool

  def initialize(size)
    @size = size
    @jobs = Queue.new

    # Each thread store its’ index in a thread-local variable, in case we
    # need to know which thread a job is executing in later on.  
    @pool = Array.new(@size) do |i|
      Thread.new do
        Thread.current[:id] = i

	# Shutdown of threads
        catch(:exit) do
          loop do
            job, args = @jobs.pop
            job.call(*args)
          end
        end
      end
    end
  end
  
  # Tell the Pool that there is work to be done. 
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

# Start Server, Receive Client Message, Process, Reply to Client.
if $0 == __FILE__
  server = TCPServer.open(2631)
  p = Pool.new(10)

  loop do
    p.schedule(server.accept) do |client|
      sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
      message = client.gets
      if message == "HELO Tara\n"
          client.puts("HELO Tara\nRemote IP: #{remote_ip}\nPort: 2626\nStudentID: 11374331")
          client.close
        elsif message == "KILL_SERVICE\n"
          client.puts("Service Killed")
          client.close
        else
          client.puts("Aw you put your own message! I'm just going to say Hey! Bye..")
          client.close
      end
    end
  end
  server.close
  at_exit { p.shutdown }
end
