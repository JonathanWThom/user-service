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
    random_name = ('a'..'z').to_a.shuffle[0,8].join
    random_email = ('a'..'z').to_a.shuffle[0,8].join
    user = Client::User.create(
      :name => random_name,
      :email => random_email,
      :password => 'whatev')
    expect(user["name"]).to eq random_name
    expect(user["email"]).to eq random_email
    expect(Client::User.find_by_name(random_name)).to eq user
  end

  it "should update a user" do
    user = Client::User.update("Jonathan", {bio: "Fixing deprecation warnings"})
    expect(user["name"]).to eq("Jonathan")
    expect(user["bio"]).to eq("Fixing deprecation warnings")
    expect(Client::User.find_by_name("Jonathan")).to eq(user)
  end
end
