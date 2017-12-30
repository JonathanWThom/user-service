ENV['SINATRA_ENV'] = 'test'

require File.dirname(__FILE__) + "/../service"
require "rspec"
require "rack/test"

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

describe "service" do
  before(:each) do
    User.delete_all
  end

  def get_attributes(json_response)
    JSON.parse(json_response.body)
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
      expect(last_response.status).to eq 200
      attributes = get_attributes(last_response)
      expect(attributes["name"]).to eq "Jonathan"
    end

    it "should return a user with an email" do
      get "/api/v1/users/Jonathan"
      expect(last_response.status).to eq 200
      attributes = get_attributes(last_response)
      expect(attributes["email"]).to eq "jonathan.thom1990@gmail.com"
    end

    it "should not return a user's password" do
      get "/api/v1/users/Jonathan"
      expect(last_response.status).to eq 200
      attributes = get_attributes(last_response)
      expect(attributes).to_not have_key(:password)
    end

    it "should return a user with a bio" do
      get "/api/v1/users/Jonathan"
      expect(last_response.status).to eq 200
      attributes = get_attributes(last_response)
      expect(attributes["bio"]).to eq "I love my dog."
    end

    it "should return a 404 for a user that doesn't exist" do
      get "/api/v1/users/foo"
      expect(last_response.status).to eq 404
    end
  end

  describe "POST on /api/v1/users" do
    it "should create a user" do
      post "/api/v1/users", {
        name: "Ernie",
        email: "erniethedog@gmail.com",
        password: "ilovetreats",
        bio: "hello this is dog"
      }.to_json
      expect(last_response.status).to eq 200
      get "/api/v1/users/Ernie"
      attributes = get_attributes(last_response)
      expect(attributes["name"]).to eq "Ernie"
      expect(attributes["email"]).to eq "erniethedog@gmail.com"
      expect(attributes["bio"]).to eq "hello this is dog"
    end
  end
end
