#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe ReportAPI::V1 do

  def app
    ReportAPI::V1
  end

  let(:rabl_root) do
    Project.join 'views'
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

  let(:completed_report) do
    Presenter::Clock.new completed_clock
  end

  let(:employee) do
    Fabricate.build(:employee)
  end

  let(:employee_presenter) do
    Report::EmployeePresenter.new employee
  end

  describe "GET /api/v1/reports/monthly/employee.xls" do

    it "returns a monthly report of an employee" do
      Employee.should_receive(:monthly_data_by_employee).and_return employee
      Employee.any_instance.should_receive(:clocks).and_return [completed_clock]
      Presenter::Clock.any_instance.stub(:completed_report)
      Presenter::Employee.any_instance.stub(:employee_presenter)
      get "/api/v1/reports/monthly/employee.xls",{
        employee_id: 1,
        month: 4,
        year: 2014
        },{'api.tilt.root' => rabl_root}

      last_response.status.should == Rack::Utils.status_code(:ok)
      last_response.body.should == \
%Q{<table border="1">
  <thead>
    <th>FECHA</th>
    <th>HORA DE ENTRADA</th>
    <th>HORA DE SALIDA</th>
    <th>TOTAL HORAS</th>
  </thead>
    <tr>
      <td>01:06:09</td>
      <td>01:06:09</td>
      <td>05:05:02</td>
      <td>4</td>
    </tr>
</table>
}
    end

  end
end
