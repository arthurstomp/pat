require 'rails_helper'

RSpec.describe "Companies API", type: :request do
  let(:user) { create :user }
  let(:company) { create :company, user: user }

  describe "GET /companies" do
    it "returns all companies owned by user" do
      n_companies = 3
      n_companies.times do
        create :company, user: user
      end
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      create :department, company: company
      get "/companies",
        params: {
          relationship_to_company: "owned",
          number_of_departments: true,
          number_of_employees: true
        }, headers: headers
      companies_json = JSON.parse(response.body)["companies"]
      companies = JSON.parse(companies_json)
      expect(companies.count).to eq n_companies + 1
    end

    it "returns all companies admin by user" do
      n_companies = 3
      n_companies.times do
        create :company, user: user
      end
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/companies", params: {relationship_to_company: "admin"}, headers: headers
      companies_json = JSON.parse(response.body)["companies"]
      companies = JSON.parse(companies_json)
      expect(companies.count).to eq n_companies
    end

    it "returns all companies user is member" do
      n_companies = 3
      n_companies.times do
        create :company, user: user
      end
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/companies", params: {relationship_to_company: "member"}, headers: headers
      get "/companies", params: {relationship_to_company: nil}, headers: headers
      companies_json = JSON.parse(response.body)["companies"]
      companies = JSON.parse(companies_json)
      expect(companies.count).to eq n_companies
    end
  end

  describe "POST /companies/" do
    it "returns company" do
      post "/companies",
        headers: login(user),
        params: {company: {name: "Test"}}
      expect(response).to have_http_status(200)
      company_json = JSON.parse(response.body)['company']
      returned_company = JSON.parse(company_json)
      expect(returned_company["name"]).to eq("Test")
    end

    it "return messages if fails" do
      post "/companies",
        headers: login(user),
        params: {company: {name: nil}}
      expect(response).to have_http_status(400)
    end
  end

  describe "GET /companies/:id/report" do
    it "return jobs on report" do
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      d1 = create :department, company: company
      d2 = create :department, company: company
      d3 = create :department, company: company
      deps = [d1,d2,d3]
      20.times do
        rand_dep_index = Random.rand(0..deps.length - 1)
        d = deps[rand_dep_index]
        create :employee, company: company, department: d
      end
      get "/companies/#{company.id}/report", headers: headers
      jobs = JSON.parse(response.body)["report_jobs"]
      expect(jobs.count).to eq 9
    end
  end

  describe "GET /companies/:id" do
    it "return a company" do
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/companies/#{company.id}", headers: headers
      company_json = JSON.parse(response.body)['company']
      returned_company = JSON.parse(company_json)
      expect(returned_company["name"]).to eq(company.name)
    end
  end

  describe "DELETE /companies/:id" do
    it "delete company" do
      delete "/companies/#{company.id}", headers: login(user)
      expect(response).to have_http_status(204)
      expect(Company.where(id: company.id)).to eq []
    end
  end
end
