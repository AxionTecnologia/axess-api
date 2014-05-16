require 'spec_helper'

describe Validator::Rut do

  module ValidationsSpec
    module RutValidatorSpec
      class API < Grape::API
        default_format :json

        params do
          requires :rut, rut: true
        end
        get do

        end
      end
    end
  end

  def app
    ValidationsSpec::RutValidatorSpec::API
  end

  it "accepts a correct rut" do
    ['16.056.807-0','11.509.745-8','11.739.106-K'].each do |rut|
      get '/', rut: rut
      last_response.status.should == Rack::Utils.status_code(:ok)
    end
  end

  it "refuses an incorrect rut" do
    get '/', rut: '16.056.807-K'
    last_response.status.should == Rack::Utils.status_code(401)
  end

  it "refuses a not present rut" do
    get '/'
    last_response.status.should == Rack::Utils.status_code(401)
  end
end
