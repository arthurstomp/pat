require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let(:user) { create :user }

  describe "GET /users" do
    it "returns all users" do
      n_users = 3
      3.times do
        create :user
      end
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/users", headers: headers
      users_json = JSON.parse(response.body)["users"]
      users = JSON.parse(users_json)
      expect(users.count).to eq n_users + 1 # Remember let user!
    end
  end

  describe "POST /users/login" do
    it "returns user with jwt" do
      post "/users/login",
        headers: json_headers,
        params: {user: {email: user.email, username: user.username}}
      expect(response).to have_http_status(:ok)
      returned_user = JSON.parse(response.body)
      expect(returned_user["jwt"]).not_to be user.jwt
    end

    it "create new user and return it with jwt" do
      post "/users/login",
        headers: json_headers,
        params: {user: {email: "test@test.com", username: "hello"}}
      expect(response).to have_http_status(:ok)
      returned_user = JSON.parse(response.body)
      expect(returned_user["jwt"]).not_to be nil
    end

    it "return messages if fails" do
      post "/users/login",
        headers: json_headers,
        params: {user: {email: "test", username: "hello"}}
      expect(response).to have_http_status(400)
    end
  end

  describe "GET /users/:id" do
    it "return a user" do
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/users/#{user.id}", headers: headers
      returned_user = JSON.parse(response.body)
      expect(returned_user["jwt"]).to eq(user.jwt)
    end
  end

  describe "PUT /users/:id" do
    it "updates user" do
      put "/users/#{user.id}",
        params: {user: {username: "test"}},
        headers: login(user)
      returned_user = JSON.parse(response.body)
      user.reload
      expect(returned_user["jwt"]).to eq(user.jwt)
      expect(returned_user["username"]).to eq("test")
    end

    it "return messages if fails" do
      put "/users/#{user.id}",
        headers: login(user),
        params: {user: {email: "s", username: "hello"}}
      expect(response).to have_http_status(400)
    end
  end

  describe "DELETE /users/:id" do
    it "delete current_user" do
      delete "/users/#{user.id}", headers: login(user)
      expect(response).to have_http_status(204)
      expect(User.where(id: user.id)).to eq []
    end
  end
end
