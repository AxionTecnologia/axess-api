#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe EmployeePresenter do

  before do
    @employee = EmployeePresenter.new Fabricate.build :employee
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

end
