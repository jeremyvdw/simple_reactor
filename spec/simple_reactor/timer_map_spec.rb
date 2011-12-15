require 'spec_helper'

describe SimpleReactor::TimerMap do
  let!(:time_now) { Time.now }
  let(:proc) { Proc.new { |arg| "Hi #{arg} from the block!" } }
  let(:args) { '5' }

  before do 
    subject[(time_now + 15).to_i] = [proc, 15]
    subject[(time_now + 10).to_i] = [proc, 10]
    subject[(time_now + 5).to_i]  = [proc, 5]
  end

  it "#[]= keeps a @sorted_keys array up to date" do
    subject.sorted_keys.first.should eq (time_now + 5).to_i
  end

  it "#delete keeps the @sorted_keys up to date" do
    subject.delete (time_now + 5).to_i
    subject.sorted_keys.first.should eq (time_now + 10).to_i
  end

  it "#next_time returns the @sorted_keys first value" do
    subject.next_time.should eq (time_now + 5).to_i
  end

  it "#shift returns the next event (as array)" do
    next_event = [subject.next_time, subject[subject.next_time]]
    subject.shift.should eq next_event
    subject.keys.should_not include next_event
  end

  describe "#add_timer" do
    it "stores a new timer for given seconds later from now" do
      subject.add_timer(2, '5', &proc).should eq [proc, args]

      subject.next_time.to_i.should eq (time_now + 2).to_i
      subject[subject.next_time].should eq [proc, args]
    end

    it "stores a new timer for a given Time" do
      subject.add_timer(time_now + 2, '5', &proc).should eq [proc, args]

      subject.next_time.to_i.should eq (time_now + 2).to_i
      subject[subject.next_time].should eq [proc, args]
    end
  end
  
  it "#call_next_timer call next-to-come block code with given args" do
    subject.add_timer(1, 'John') do |arg|
      "What are you looking at #{arg} ?"
    end
    subject.call_next_timer.should eq "What are you looking at John ?"
  end

end