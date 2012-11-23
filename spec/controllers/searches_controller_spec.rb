require 'spec_helper'

describe SearchesController do

  describe "GET 'contractors'" do
    it "returns http success" do
      get 'contractors'
      response.should be_success
    end
  end

  describe "GET 'owners'" do
    it "returns http success" do
      get 'owners'
      response.should be_success
    end
  end

  describe "GET 'agents'" do
    it "returns http success" do
      get 'agents'
      response.should be_success
    end
  end

  describe "GET 'suppliers'" do
    it "returns http success" do
      get 'suppliers'
      response.should be_success
    end
  end

end
