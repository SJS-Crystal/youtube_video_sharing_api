require "rails_helper"

RSpec.describe "API User V1 Users Routing", type: :routing do
  it "routes GET /api/user/v1 to document#index" do
    expect(get: "/api/user/v1").to route_to("api/user/v1/document#index")
  end

  it "routes POST /api/user/v1/users to users#create" do
    expect(post: "/api/user/v1/users").to route_to("api/user/v1/users#create")
  end

  it "routes POST /api/user/v1/users/login to users#login" do
    expect(post: "/api/user/v1/users/login").to route_to("api/user/v1/users#login")
  end

  it "routes DELETE /api/user/v1/users/logout to users#logout" do
    expect(delete: "/api/user/v1/users/logout").to route_to("api/user/v1/users#logout")
  end
end
