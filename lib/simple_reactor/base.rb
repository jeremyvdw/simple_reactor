class SimpleReactor::Base

  def initialize
    @running = false
    @timers = SimpleReactor::TimerMap.new
    @block_buffer = []
  end

  def add_timer(time, *args, &block)
    time = time.to_i if Time === time
    @timers.add_timer time, *args, &block
  end

end