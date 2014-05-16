require 'spec_helper'

describe Axess::API do

  def app
    Axess::API
  end

  it "swagger documentation" do
    get "/api/swagger_doc"
    last_response.status.should == 200
    json_response = JSON.parse last_response.body
    json_response["apiVersion"].should == "v1"
    json_response["apis"].size.should == 3
  end

end
