#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe EmployeeAPI::V1 do

  def app
    EmployeeAPI::V1
  end

  let(:rabl_root) do
    Project.join 'views'
  end

  let(:employee) do
    Fabricate.build :employee
  end

  describe "GET /api/v1/employees" do

    it "returns an empty list of employees" do
      Employee.should_receive(:by_active).and_return []
      get "/api/v1/employees",{},{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(:ok)
      last_response.body.should == {"employees"=>[]}.to_json
    end

    it "returns a list of employees" do
      Employee.should_receive(:by_active).and_return [employee]
      get "/api/v1/employees",{},{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(:ok)
      last_response.body.should == {
        "employees"=>[{
          'id'  => employee.id,
          'rut' => '16.056.807-0',
          'name' => 'Andrés',
          'last_name' => 'Otárola Alvarado',
          'active' => true
      }]}.to_json
    end
  end

  describe "POST /api/v1/employees" do

    it "returns 201 for a created employee" do
      Employee.should_receive(:create).and_return true
      post "/api/v1/employees",{
        rut: "16.056.807-0",
        name: "Andrés",
        last_name: "Otárola Alvarado"
      },{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(:created)
      last_response.body.should == {}.to_json
    end


    it "returns 400 for a failed employee create attempt" do
      Employee.should_receive(:create).and_raise(Sequel::ValidationFailed.new 'rut is already taken')
      post "/api/v1/employees",{
        rut: "16.056.807-0",
        name: "Andrés",
        last_name: "Otárola Alvarado"
      },{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(400)
      last_response.body.should == {
        "error" => "rut is already taken"
        }.to_json
    end
  end


  describe "PUT /api/v1/employees" do

    let(:employee){
      Fabricate.build(:employee)
    }

    it "returns 200 for a created employee" do
      Employee.should_receive(:[]).and_return employee
      Employee.any_instance.should_receive(:update).and_return employee
      put "/api/v1/employees",{
        id: 1,
        rut: "16.056.807-0",
        name: "Andrés",
        last_name: "Otárola Alvarado"
      },{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(:ok)
      last_response.body.should == {}.to_json
    end


    it "returns 401 for a employee record not found" do
      Employee.should_receive(:[]).and_return nil
      put "/api/v1/employees",{
        id: 1,
        rut: "16.056.807-0",
        name: "Andrés",
        last_name: "Otárola Alvarado"
      },{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(401)
      last_response.body.should == {
        "error" => "Record could not be found"
        }.to_json
    end

    it "returns 402 for a employee update attempt" do
      Employee.should_receive(:[]).and_return employee
      Employee.any_instance.should_receive(:update).and_raise(Sequel::ValidationFailed.new 'Record could not be updated')
      put "/api/v1/employees",{
        id: 1,
        rut: "16.056.807-0",
        name: "Andrés",
        last_name: "Otárola Alvarado"
      },{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(402)
      last_response.body.should == {
        "error" => "Record could not be updated"
        }.to_json
    end

  end

end
