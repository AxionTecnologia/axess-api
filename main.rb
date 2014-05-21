module Axess
  class API < Grape::API
    prefix 'api'
    format :json
    formatter :json, Grape::Formatter::Rabl

    mount ::EmployeeAPI::V1
    mount ::ClockAPI::V1
    mount ::ReportAPI::V1
    add_swagger_documentation api_version: 'v1'
  end
end
