require 'spec_helper'

describe SimpleReactor::TimerMap do
  let(:proc) { Proc.new { |arg| "Hi #{arg} from the block!" } }
  let(:args) { '5' }

  before do 
    Timecop.freeze

    [5, 10, 15].sort.each do |time|
      subject[(Time.now + time).to_i] = [proc, time]
    end
  end

  describe "#[]=" do
    it "keeps a @sorted_keys array up to date" do
      subject.sorted_keys.should eq subject.keys.sort
    end
  end

  describe "#delete" do
    it "keeps the @sorted_keys up to date" do
      subject.delete (Time.now + 5).to_i
      subject.sorted_keys.should eq subject.keys.sort
    end
  end

  describe "#next_time" do
    it "returns the @sorted_keys first value" do
      next_scheduled_at = subject.keys.first
      subject.next_time.should eq next_scheduled_at
    end
  end

  describe "#shift" do
    it "returns the next event (as array)" do
      next_event = subject.first
      subject.shift.should eq next_event
      subject.keys.should_not include next_event
    end
  end

  describe "#add_timer" do
    let(:two_minutes_from_now) { (Time.now + 2).to_i }

    it "stores a new timer for given seconds later from now" do
      subject.add_timer(2, args, &proc).should eq [proc, args]

      subject.next_time.should eq two_minutes_from_now
      subject[subject.next_time].should eq [proc, args]
    end

    it "stores a new timer for a given Time" do
      subject.add_timer(2, args, &proc).should eq [proc, args]
      subject.next_time.should eq two_minutes_from_now
      subject[subject.next_time].should eq [proc, args]
    end
  end
  
  describe "#call_next_timer" do
    it "calls next-to-come block code with given args" do
      subject.add_timer(1, 'John') do |arg|
        "What are you looking at #{arg} ?"
      end
      subject.call_next_timer.should eq "What are you looking at John ?"
    end
  end

end
