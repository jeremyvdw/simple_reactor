require 'spec_helper'
require 'pry'

describe SimpleReactor::Base do

  it "#initialize set defaults attributes" do
    subject.instance_variable_get(:@running).should be_false
    subject.instance_variable_get(:@timers).should be_kind_of SimpleReactor::TimerMap
    subject.instance_variable_get(:@timers).empty?.should be_true
    subject.instance_variable_get(:@block_buffer).should eq []
  end

  it "#add_timer pushes given timer to TimerMap#add_timer" do
    time, args, proc = Time.now + 5, 5, Proc.new { |arg| "Hi #{arg}!" }
    subject.instance_variable_get(:@timers).should_receive(:add_timer).with(time.to_i, args, &proc)
    subject.add_timer time, args, &proc
  end
end