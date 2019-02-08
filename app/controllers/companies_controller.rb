class CompaniesController < ApplicationController
  include Pundit

  wrap_parameters format: [:json]

  before_action :authenticate

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    companies = policy_scope(Company.all)
    fm = FrontMakeup::Company::Scope.new(current_user,companies)
    render json: {companies: fm.serve_request(req_params).target!}
  end

  def show
    company = Company.find(params[:id])
    authorize company
    render json: { company: FrontMakeup::Company.new(company, current_user).to_build_for.target!}
  end

  def report
    company = Company.find(params[:id])
    authorize(company)
    limit = params[:limit] || 3
    employees = company.report(limit)
    render json: report_json(employees).target!
  end


  def create
    company = Company.new(company_params)
    company.user = current_user
    authorize(company)
    if company.save
      render json: { company: FrontMakeup::Company.new(company, current_user).to_build_for.target!}
    else
      render json: company.errors.full_messages, status: 400
    end
  end

  def destroy
    company = Company.find(params[:id])
    authorize company
    company.destroy
    render json: nil, status: 204
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end

  def req_params
    params.permit(:relationship_to_company, :number_of_employees, :number_of_departments)
  end

  def report_json(jobs)
    Jbuilder.new do |jb|
      jb.report_jobs jobs do |j|
        jb.id j.id
        jb.name j.user.username
        jb.role j.role
        jb.salary j.salary
        jb.company j.company.name
        jb.department j.department.name
      end
    end
  end
end
