require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let(:user) { create :user }
  let(:job) { create :employee, user: user }

  describe "GET /jobs" do
    it "returns all jobs" do
      n_jobs = 3
      3.times do
        create :employee, user: user
      end
      company = job.company
      create :department, company: company
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/jobs", headers: headers
      jobs_json = JSON.parse(response.body)["jobs"]
      jobs = JSON.parse(jobs_json)
      expect(jobs.count).to eq n_jobs + 1
    end
  end

  describe "GET /jobs/:id" do
    it "return a job" do
      headers = {"Content-Type"=> "application/json"}.merge(login(user))
      get "/jobs/#{job.id}", headers: headers
      job_json = JSON.parse(response.body)["job"]
      returned_job = JSON.parse(job_json)
      expect(returned_job["id"]).to eq job.id
    end
  end

  describe "POST /companies/" do
    it "returns job" do
      company = create :company, user: user
      department = create :department, company: company 
      post "/jobs",
        headers: login(user),
        params: {
          job: {
            salary: 1200,
            company_id: company.id,
            user_id: user.id,
            department_id: department.id,
            role: "administrator"
          }
        }
      expect(response).to have_http_status(200)
      job_json = JSON.parse(response.body)['job']
      returned_job = JSON.parse(job_json)
      expect(returned_job["salary"]).to eq(1200)
    end

    it "return messages if fails" do
      company = create :company, user: user
      department = create :department, company: company 
      employee = create :employee_admin, user: user
      post "/jobs",
        headers: login(user),
        params: {job: {user: user, role: nil}}
      expect(response).to have_http_status(400)
    end
  end

  describe "PUT /jobs/:id" do
    it "updates job" do
      put "/jobs/#{job.id}",
        params: {job: {salary: 1666}},
        headers: login(user)
      returned_job = JSON.parse(response.body)
      job.reload
      expect(job.salary).to eq(1666)
    end

    it "return messages if fails" do
      put "/jobs/#{job.id}",
        headers: login(user),
        params: {job: {department_id: 30 }}
      expect(response).to have_http_status(400)
    end
  end
end
