#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe ClockPresenter do

  let(:new_clock) do
    ClockPresenter.new(
      Fabricate.build :clock,
      clock_in: DateTime.new(2014,2,3,3,5,6)
    )
  end

  let(:completed_clock) do
    ClockPresenter.new(
      Fabricate.build :clock,
      clock_in: DateTime.new(2014,2,3,1,5,6),
      clock_out: DateTime.new(2014,2,3,3,5,6)
    )
  end

  context "#event" do
    context "for a new clock" do
      it "returns the clock-in event" do
        new_clock.event.should eq 'clock-in'
      end
    end

    context "for a completed clock" do
      it "returns the clock-out event" do
        completed_clock.event.should eq 'clock-out'
      end
    end
  end

  context "#timestamp" do
    it "returns the timestamp" do
      new_clock.timestamp.should eq '2014-02-03 00:05:06 -0300'
    end
  end
end
