require 'thread'

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
