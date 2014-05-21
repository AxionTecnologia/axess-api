#!/bin/env ruby
# encoding: utf-8

module EmployeeAPI
  class V1 < Grape::API
    version 'v1', using: :path, vendor: 'Axion Tecnología'
    content_type :json, "application/json;charset=UTF-8"

    resource :employees do

      desc "Lists the employees."
      get '/', rabl: 'employees/index' do
        @employees = Employee.by_active.map{ |e| Presenter::Employee.new e }
      end

      desc "Creates an employee."
      params do
        requires :rut, type: String, rut: true, desc: "RUT."
        requires :name, type: String, desc: "Name."
        requires :last_name, type: String, desc: "Last name."
      end
      post '/', rabl: 'empty' do
        rut, cv = Validator::Rut::sanitize_rut params[:rut]
        options = {rut: rut, cv: cv, name: params[:name], last_name: params[:last_name]}
        begin
          Employee.create(options)
        rescue Sequel::ValidationFailed => e
          error!(e, 400)
        end
      end

      desc "Updates an employee."
      params do
        requires :id, type: Integer, desc: "ID."
        optional :name, type: String, desc: "Name."
        optional :last_name, type: String, desc: "Last name."
        optional :active, type: Boolean, desc: "Last name."
      end
      put '/', rabl: 'empty' do
        employee = Employee[params[:id]]
        if employee
          begin
            employee.name = params[:name] unless params[:name].nil?
            employee.last_name = params[:last_name] unless params[:last_name].nil?
            employee.active = params[:active] unless params[:active].nil?
            employee.save
          rescue Sequel::ValidationFailed => e
            error!(e, 402)
          end
        else
          error!('Record could not be found', 401)
        end
      end

    end
  end
end
