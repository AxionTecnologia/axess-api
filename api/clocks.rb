#!/bin/env ruby
# encoding: utf-8

module ClockAPI
  class V1 < Grape::API
    version 'v1', using: :path, vendor: 'Axion Tecnología'
    content_type :json, "application/json;charset=UTF-8"

    resource :clocks do

      desc "Records an employee's clock-in/clock-out event."
      params do
        requires :employee_rut, type: String, rut: true, desc: "RUT."
      end
      post '/', rabl: 'clocks/post' do
        rut, cv = Validator::Rut::sanitize_rut params[:employee_rut]
        employee = Employee.by_rut rut
        if employee
          @clock = Presenter::Clock.new Clock.tick employee.id
        else
          error!('Not a valid employee rut', 400)
        end
      end

    end
  end
end
