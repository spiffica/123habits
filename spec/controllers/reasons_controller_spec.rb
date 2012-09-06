require 'spec_helper'

describe ReasonsController do

  describe "GET 'new'" do
    it "returns http success" do
      current_user = User.first
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      post 'create'
      response.should be_success
    end
  end

  describe "POST 'update'" do
    it "returns http success" do
      post 'update'
      response.should be_success
    end
  end

  describe "GET 'delete'" do
    it "returns http success" do
      get 'delete'
      response.should be_success
    end
  end

end
