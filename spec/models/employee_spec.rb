require 'spec_helper'

describe Employee do

  let(:clock_in) do
    DateTime.new 2014,2,3,1,5,6
  end

  let(:clock_out) do
    DateTime.new 2014,2,3,3,5,6
  end

  before do
    @employee = Fabricate :employee
    Fabricate :employee, rut: 12345627
    Fabricate :employee, rut: 16543456, active: false
    Fabricate(:clock, employee: @employee, clock_in: clock_in, clock_out: clock_out)
  end

  let(:rut) do
    16056807
  end

  context "#by_active" do

    it "returns 2 employees which are active" do
      result = Employee.by_active
      result.count.should eq 2
    end

  end

  context "#by_rut" do

    it "returns a single empoyee by rut" do
      result = Employee.by_rut rut
      result.rut.should eq rut
    end

  end

  context "#monthly_data" do

    it "returns a list of employees by month and year" do
      result = Employee.monthly_data({month: 2, year:2014})
      result.count.should eq 1
    end

  end

  context "#monthly_data_by_employee" do

    it "returns an employee by id, month and year" do
      result = Employee.monthly_data_by_employee({employee_id: @employee.id, month: 2, year:2014})
      result.id.should eq @employee.id
      result.clocks.count.should eq 1
    end

  end

end
