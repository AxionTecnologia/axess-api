#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe Axess::API do

  def app
    Axess::API
  end

  let(:rabl_root) do
    Project.join 'views'
  end

  let(:employee) do
    Fabricate.build :employee
  end

  let(:new_clock) do
    Fabricate.build(
      :clock,
      employee: employee,
      clock_in: DateTime.new(2014,2,3,1,5,6,'-3')
    )
  end

  let(:completed_clock) do
    Fabricate.build(
      :clock,
      employee: employee,
      clock_in: DateTime.new(2014,2,3,1,5,6,'-3'),
      clock_out: DateTime.new(2014,2,3,3,5,6,'-3')
    )
  end

  describe "POST /api/v1/clocks" do

    let(:employee_rut) do
      '16.056.807-0'
    end

    let(:sanitized_employee_rut) do
      16056807
    end

    let(:clock_presenter) do
      Presenter::Clock.new new_clock
    end

    let(:completed_clock_presenter) do
      Presenter::Clock.new completed_clock
    end

    it "returns a 400 for rut not found" do
      Employee.should_receive(:by_rut).with(sanitized_employee_rut).and_return nil
      post "/api/v1/clocks",{'employee_rut'=> employee_rut},{'api.tilt.root' => rabl_root}
      last_response.status.should == Rack::Utils.status_code(400)
      last_response.body.should == {
        "error" => "Not a valid employee rut"
        }.to_json
    end

    it "returns the created clock-in event" do
      Employee.should_receive(:by_rut).and_return employee
      Clock.should_receive(:tick).with(employee.id).and_return new_clock
      Presenter::Clock.any_instance.stub(:clock_presenter)
      post "/api/v1/clocks",{'employee_rut'=> employee_rut},{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(:created)
      last_response.body.should == {"clock"=>{
        "event" => "clock-in",
        "timestamp" => "2014-02-03 01:05:06 -0300"
        }}.to_json
    end

    it "returns the created clock-out event" do
      Employee.should_receive(:by_rut).and_return employee
      Clock.should_receive(:tick).and_return completed_clock
      Presenter::Clock.any_instance.stub(:completed_clock_presenter)
      post "/api/v1/clocks",{'employee_rut'=> employee_rut},{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(:created)
      last_response.body.should == {"clock"=>{
        "event" => "clock-out",
        "timestamp" => "2014-02-03 03:05:06 -0300"
        }}.to_json
    end

  end
end
