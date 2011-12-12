class SimpleReactor::TimerMap < Hash

  attr :sorted_keys

  def []=(k, v)
    super
    @sorted_keys = keys.sort
    v
  end

  def delete k
    v = super
    @sorted_keys = keys.sort
    v
  end

  def next_time
    @sorted_keys.first
  end

  def shift
    if @sorted_keys.empty?
      nil
    else
      first_key = @sorted_keys.shift
      value = self.delete first_key
      [first_key, value]
    end
  end

  def add_timer(time, args, &block)
    time = case time
    when Time
      time
    else
      Time.now + time.to_i
    end

    self[time] = [block, args] if block_given?
  end

  def call_next_timer
    key, value = self.shift
    blk, args = value
    blk.call(*args)
  end

end
