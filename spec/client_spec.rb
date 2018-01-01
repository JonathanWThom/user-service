require_relative '../user.rb'

describe "client" do
  before(:each) do
    Client::User.base_uri = "http://localhost:4567"
  end

  it "should get a user" do
    user = Client::User.find_by_name "Jonathan"
    expect(user["name"]).to eq "Jonathan"
    expect(user["email"]).to eq "jonathan.thom1990@gmail.com"
    expect(user["bio"]).to eq "Well grounded rubyist"
  end

  it "should return nil for a user not found" do
    user = Client::User.find_by_name "gosling"
    expect(user).to eq nil
  end

  it "should create a user" do
    user = User.create({
      name: "trotter",
      email: "no spam",
      password: "whatev"
    })
    expect(user.name).to eq("trotter")
    expect(user.email).to eq("no spam")
    expect(Client::User.find_by_name("trotter")).to eq(user)
  end
end
