require 'spec_helper'

describe ReportsController do

  describe "GET 'redetermination'" do
    it "returns http success" do
      get 'redetermination'
      response.should be_success
    end
  end

end
