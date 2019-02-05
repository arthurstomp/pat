require 'rails_helper'

RSpec.describe "Application API", type: :request do
  let(:user) { create :user }

  describe "GET root" do
    it "renders root app" do
      get "/"
      expect(response).to render_template(:root)
    end

    it "returns 401" do
      headers = {"Content-Type"=> "application/json"}
      get "/companies/", headers: headers
      expect(response).to have_http_status(401)
    end
  end
end
