#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe Presenter::Employee do

  let(:built_employee) do
    Fabricate.build :employee
  end

  before do
    @employee = Presenter::Employee.new built_employee
  end

  context "#id" do

    it "returns the id" do
      @employee.id.should eq built_employee.id
    end

  end

  context "#rut" do

    it "returns full formatted rut" do
      @employee.rut.should eq '16.056.807-0'
    end

  end

  context "#name" do

    it "returns the name" do
      @employee.name.should eq 'Andrés'
    end

  end

  context "#last_name" do

    it "returns the last name" do
      @employee.last_name.should eq 'Otárola Alvarado'
    end

  end

  context "#full_name" do

    it "returns the full name" do
      @employee.full_name.should eq 'Andrés Otárola Alvarado'
    end

  end

  describe "with clock data" do

    before do
      Employee.any_instance.should_receive(:clocks).and_return  [
      Fabricate.build(
        :clock, employee: built_employee,
        clock_in: (DateTime.now + Rational(3600, 86400)),
        clock_out: (DateTime.now + Rational(3600*8, 86400)),
        total_hours: 7
      ),
      Fabricate.build(:clock, employee: built_employee,
        clock_in: (DateTime.now + Rational(3600*24, 86400))
      )]
    end

    context "#total_days_worked" do

      it "returns the total days worked for the employee" do
        @employee.total_days_worked.should eq 2
      end

    end

    context "#total_hours" do

      it "returns the total hours worked for the employee" do
        @employee.total_hours.should eq 7
      end

    end

  end

end
