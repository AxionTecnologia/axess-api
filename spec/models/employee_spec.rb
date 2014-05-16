require 'spec_helper'

describe Employee do

  before do
    Fabricate :employee
    Fabricate :employee, rut: 12345627
    Fabricate :employee, rut: 16543456, active: false
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

end
