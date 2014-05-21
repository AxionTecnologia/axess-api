#!/bin/env ruby
# encoding: utf-8

module ReportAPI
  class V1 < Grape::API
    version 'v1', using: :path, vendor: 'Axion Tecnología'
    content_type :json, "application/json;charset=UTF-8"
    content_type :xls, "application/vnd.ms-excel"
    formatter :xls, XlsFormatter

    resource :reports do

      namespace :monthly do

        desc "Generates monthly report."
        params do
          requires :month, type: Integer, desc: "Month."
          requires :year, type: Integer, desc: "Year."
        end
        post '/', xls: 'reports/monthly' do
          @report = Employee.monthly_data(params).map{ |e| Presenter::Employee.new e }
        end

        desc "Generates employee monthly report."
        params do
          requires :employee_id, type: Integer, desc: "Rut."
          requires :month, type: Integer, desc: "Month."
          requires :year, type: Integer, desc: "Year."
        end
        get '/employee', xls: 'reports/employee' do
          employee = Employee.monthly_data_by_employee(params)
          @report = {
            employee: Presenter::Employee.new(employee),
            clocks: employee.clocks.map { |e| Presenter::Clock.new e }
          }
        end

      end
    end
  end
end
