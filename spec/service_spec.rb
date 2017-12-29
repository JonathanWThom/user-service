require File.dirname(__FILE__) + "/../service"
require "spec"
require "spec/interop/test"
require "rack/test"
set :environment, :test
Test::Unit::TestCase.send :include, Rake::Test::Methods

def app
  Sinatra::Application
end

describe "service" do
  before(:each) do
    User.delete_all
  end

  describe "GET on /api/v1/users/:id" do
    before(:each) do
      User.create(
        name: "Jonathan",
        email: "jonathan.thom1990@gmail.com",
        password: "password",
        bio: "I love my dog."
      )
    end

    it "should return a user by name" do
      get "/api/v1/users/Jonathan"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["name"].should == "Jonathan"
    end

    it "should return a user with an email" do
      get "/api/v1/users/Jonathan"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["email"].should == "jonathan.thom1990@gmail.com"
    end

    it "should not return a user's password" do
      get "/api/v1/users/Jonathan"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes.should_not have_key("password")
    end

    it "should return a user with a bio" do
      get "/api/v1/users/Jonathan"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["bio"].should == "I love my dog."
    end

    it "should return a 404 for a user that doesn't exist" do
      get "/api/v1/users/foo"
      last_response.status.should == 404
    end
  end
end
