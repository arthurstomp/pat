require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let(:user) { create :user }
  def login_headers(user)
    {"AUTHORIZATION" => "Bearer: #{user.jwt}"}
  end
  it "returns current_user info" do
    get "users/", {}, login_headers(user)
    expect(response).to have_http_status(:ok)
  end

  it "create new user" do
    post "users/", params: {user: attributes_for(:user)}
    expect(response).to have_http_status(:created)
  end

  #it "update current_user" do
    #patch "users/", params: {user: {email: "new_email@test.com"}}, login_headers(user)
    #expect(response).to have_http_status(:ok)
  #end

  it "delete current_user" do
    delete "users/", {},  login_headers(user)
    expect(response).to have_http_status(:nothing)
  end
end
