require 'rails_helper'

RSpec.describe "Departments API", type: :request do
  let(:user) { create :user }
  let(:company) { create :company, user: user }
  let(:department) { create :department, company: company }

  describe "GET /companies/:company_id/departments/:id" do
    it "returns all departments" do
      n_departments = 3
      n_departments.times do
        create :department, company: company
      end
      employee = create :employee, company: company, department: department
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/companies/#{company.id}/departments", headers: headers
      departments_json = JSON.parse(response.body)["departments"]
      departments = JSON.parse(departments_json)
      expect(departments.count).to eq n_departments + 1
    end
  end

  describe "POST /companies/:company_id/departments" do
    it "returns company" do
      post "/companies/#{company.id}/departments",
        headers: login(user),
        params: {department: {name: "Test"}}
      expect(response).to have_http_status(200)
      department_json = JSON.parse(response.body)['department']
      returned_department = JSON.parse(department_json)
      expect(returned_department["name"]).to eq("Test")
    end

    it "return messages if fails" do
      post "/companies/#{company.id}/departments/",
        headers: login(user),
        params: {department: {name: nil}}
      expect(response).to have_http_status(400)
    end
  end

  describe "GET /companies/:company_id/departments/:id" do
    it "return a department" do
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      department = create(:department, company: company)
      create :employee, company: company, department: department
      get "/companies/#{company.id}/departments/#{department.id}", headers: headers
      department_json = JSON.parse(response.body)['department']
      returned_department = JSON.parse(department_json)
      expect(returned_department["name"]).to eq(department.name)
    end
  end

  describe "PUT /companies/:company_id/departments" do
    it "returns company" do
      department = create :department, company: company
      put "/companies/#{company.id}/departments/#{department.id}",
        headers: login(user),
        params: {department: {name: "Testt"}}
      expect(response).to have_http_status(200)
      department_json = JSON.parse(response.body)['department']
      returned_department = JSON.parse(department_json)
      expect(returned_department["name"]).to eq("Testt")
    end

    it "return messages if fails" do
      put "/companies/#{company.id}/departments/#{department.id}",
        headers: login(user),
        params: {department: {name: nil}}
      expect(response).to have_http_status(400)
    end
  end
end
