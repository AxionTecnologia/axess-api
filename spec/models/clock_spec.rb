require 'spec_helper'

describe Clock do

  let(:employee) do
    Fabricate :employee
  end

  let(:clock_in) do
    DateTime.new 2014,2,3,1,5,6
  end

  let(:clock_out) do
    DateTime.new 2014,2,3,3,5,6
  end

  context "#tick" do

    context "when shift starts" do

      it "returns a clock-in record" do
        DateTime.should_receive(:now).and_return clock_in
        clock = Clock.tick employee.id
        clock.clock_in.should eq clock_in
        clock.clock_out.should eq nil
      end

    end

    context "when shift ends" do

      before do
        Fabricate :clock, employee: employee, clock_in: clock_in
        DateTime.should_receive(:now).and_return clock_out
        @clock = Clock.tick employee.id
      end

      it "returns a clock-out record" do
        @clock.clock_in.should eq clock_in
        @clock.clock_out.should eq clock_out
      end

      it "calculates the total hour" do
        @clock.total_hours.should eq 2
      end

    end

    context "multiple requests" do

      it "returns the correct clock event for recurring requests" do
        clock = Clock.tick employee.id
        clock.clock_in.should_not be_nil
        clock.clock_out.should be_nil
        clock = Clock.tick employee.id
        clock.clock_in.should_not be_nil
        clock.clock_out.should_not be_nil
        clock = Clock.tick employee.id
        clock.clock_in.should_not be_nil
        clock.clock_out.should be_nil
      end

    end

  end

end
