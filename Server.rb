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

# Demonstration
# -------------
# Running this file will display how the thread pool works.
if $0 == __FILE__
    server = TCPServer.open(2626)
    p = Pool.new(10)

loop do
    p.schedule(server.accept) do |client|
        client.puts("Job #{i} finished by thread #{Thread.current[:id]}")
        client.close
    end
end

  at_exit { p.shutdown }
end
