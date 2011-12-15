class SimpleReactor::Base

  def initialize
    @running = false
    @timers = SimpleReactor::TimerMap.new
    @block_buffer = []
  end

  def add_timer(time, *args, &block)
    @timers.add_timer time, *args, &block
  end

  def next_tick(&block)
    @block_buffer << block
  end

  def stop
    @running = false
  end

  def run
    @running = true

    yield self if block_given?

    tick while running
  end

  def tick
    handle_pending_block
    handle_events
    handle_timers
  end

  def handle_pending_block
    @block_buffer.size.times { @block_buffer.shift.call }
  end

  def handle_events
  end

  def handle_timers
    now = Time.now.to_i
    @timers.call_next_timer while !@timers.empty? && @timers.next_time < now
  end

end