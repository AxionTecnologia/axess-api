#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe Presenter::Clock do

  let(:employee) do
    Fabricate.build :employee
  end

  let(:new_clock) do
    Fabricate.build(
      :clock,
      employee: employee,
      clock_in: DateTime.new(2014,7,3,5,6,6)
    )
  end

  let(:completed_clock) do
    Fabricate.build(
      :clock,
      employee: employee,
      clock_in: DateTime.new(2014,7,3,5,6,9),
      clock_out: DateTime.new(2014,7,3,9,5,2),
      total_hours: 4
    )
  end

  before do
    @first_clock_in = Presenter::Clock.new new_clock
    @completed_clock = Presenter::Clock.new completed_clock
  end


  context "#event" do
    context "for a new clock" do
      it "returns the clock-in event" do
        @first_clock_in.event.should eq 'clock-in'
      end
    end

    context "for a completed clock" do
      it "returns the clock-out event" do
        @completed_clock.event.should eq 'clock-out'
      end
    end
  end

  context "#timestamp" do
    it "returns the timestamp" do
      @first_clock_in.timestamp.should eq '2014-07-03 01:06:06 -0400'
    end
  end

  context "#date_in" do

    it "returns the formatted date" do
      @first_clock_in.date_in.should eq '03/07/2014'
    end

  end

  context "#clock_in" do

    it "returns the formatted time" do
      @first_clock_in.clock_in.should eq '01:06:06'
    end

  end

  context "#clock_out" do

    it "returns the formatted time" do
      @completed_clock.clock_out.should eq '05:05:02'
    end

    it "returns nil for an on-going shift" do
      @first_clock_in.clock_out.should eq nil
    end

  end

  context "#total_hours" do

    it "returns the full name" do
      @completed_clock.total_hours.should eq 4
    end

  end


end
