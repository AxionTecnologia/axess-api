#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe ReportPresenter do

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
    @first_clock_in_report = ReportPresenter.new new_clock
    @completed_report = ReportPresenter.new completed_clock
  end


  context "#date_in" do

    it "returns the formatted date" do
      @first_clock_in_report.date_in.should eq '03/07/2014'
    end

  end

  context "#clock_in" do

    it "returns the formatted time" do
      @first_clock_in_report.clock_in.should eq '01:06:06'
    end

  end

  context "#clock_out" do

    it "returns the formatted time" do
      @completed_report.clock_out.should eq '05:05:02'
    end

    it "returns nil for an on-going shift" do
      @first_clock_in_report.clock_out.should eq nil
    end

  end

  context "#total_hours" do

    it "returns the full name" do
      @completed_report.total_hours.should eq 4
    end

  end

end
