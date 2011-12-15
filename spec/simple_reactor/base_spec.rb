require 'spec_helper'

describe SimpleReactor::Base do
  let(:proc) { Proc.new { "Hi from the block!"} }
  
  describe "#initialize" do
    it " set defaults attributes" do
      subject.instance_variable_get(:@running).should be_false
      subject.instance_variable_get(:@timers).should be_kind_of SimpleReactor::TimerMap
      subject.instance_variable_get(:@timers).empty?.should be_true
      subject.instance_variable_get(:@block_buffer).should eq []
    end
  end

  describe "#add_timer" do
    it "pushes given timer to TimerMap#add_timer" do
      time, args, proc = Time.now + 5, 5, Proc.new { |arg| "Hi #{arg}!" }
      subject.instance_variable_get(:@timers).should_receive(:add_timer).with(time, args, &proc)
      subject.add_timer time, args, &proc
    end
  end

  describe "#next_tick" do
    it "append a new proc to the block_buffer" do
      subject.next_tick &proc
      subject.instance_variable_get(:@block_buffer).size.should eq 1
      subject.instance_variable_get(:@block_buffer).should eq [proc]
    end
  end

  describe "#stop" do
    it "stops the reactor"
  end

  describe "#tick" do
    it "call the next proc shifted from the block_buffer" do
      subject.should_receive(:handle_pending_block)
    end
    
    it "call for incomming event" do
      subject.should_receive(:handle_events)
    end
    
    it "call scheduled tasks" do
      subject.should_receive(:handle_timers)
    end
    
    after { subject.tick }
  end

  describe "#handle_pending_block" do
    context "when @block_buffer is empty" do
      it "returns zero" do
        subject.handle_pending_block.should be 0
      end
    end

    context "when @block_buffer contains 1 element" do
      it "calls the proc in block_buffer heap" do
        subject.next_tick &proc
        subject.instance_variable_get(:@block_buffer).first.should_receive(:call)
        subject.handle_pending_block
      end
    end

    context "when @block_buffer contains many elements" do
      it "calls all procs in block_buffer heap" do
        3.times { subject.next_tick &proc }
        subject.instance_variable_get(:@block_buffer).each { |buffer| buffer.should_receive(:call) }
        subject.handle_pending_block
        subject.instance_variable_get(:@block_buffer).should be_empty
      end
    end

  end

  describe "#handle_events" do
    it "does nothing for now"
  end

  describe "#handle_timers" do
    context "when no timers has been set up" do
      it "returns 0" do
        subject.handle_timers.should be_nil
      end
    end

    context "when a timer has been set up" do
      it "calls timer on time" do
        now = Time.now - 1
        proc.should_receive(:call).and_return(true)
        subject.add_timer now, nil, &proc
        subject.handle_timers
      end

      it "doesn't call timer before time" do
        now = Time.now + 5
        proc.should_not_receive(:call).and_return(true)
        subject.add_timer now, nil, &proc
        subject.handle_timers
      end
    end
  end

  describe "#run" do
    it "starts the reactor"
  end
end