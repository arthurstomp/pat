class DepartmentsController < ApplicationController
  include Pundit

  wrap_parameters format: [:json]

  before_action :authenticate

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    departments = company.departments
    policy_scope(departments)
    render json: {departments: departments_json(departments).target!}
  end

  def show
    department = company.departments.find(params[:id])
    if authorize(department)
      render json: { department: department_json(department).target! }
    else
      render nothing: true, status: 400
    end
  end

  def create
    department = company.departments.new(department_params)
    if authorize(department) && department.save
      render json: {department: department_json(department)}
    else
      render json: department.errors.full_messages, status: 400
    end
  end

  def members
    department = company.departments.find(params[:id])
    if authorize(departments)
      render json: {department: department_json(department)}
    else
      render json: department.errors.full_messages, status: 400
    end
  end

  def update
    department = company.departments.find(params[:id])
    if authorize(department) and department.update_attributes(department_params)
      render json: {department: department_json(department.reload).target!}
    else
      render json: department.errors.full_messages, status: 400
    end
  end
  
  private

  def company
    @company = Company.find(params[:company_id])
  end

  def department_params
    params.require(:department).permit(:name)
  end

  def departments_json(departments)
    Jbuilder.new do |jb|
      jb.array! departments do |d|
        jb.id d.id
        jb.name d.name
        jb.company do 
          jb.id d.company.id
          jb.name d.company.name
        end
        jb.n_members d.members.count
        jb.n_admins d.members.where({role: Employee::Roles[:admin]}).count
        jb.set! :members do
          jb.array! d.members do |job|
            jb.id job.id
            jb.role job.role
            jb.name job.user.username
            jb.set! :company do
              jb.id job.company.id
              jb.name job.company.name
              jb.set! :departments do
                jb.array! job.company.departments do |d|
                  jb.id d.id
                  jb.name d.name
                end
              end
            end
            jb.set! :department do
              jb.id job.department.id
              jb.name job.department.name
            end
            jb.salary job.salary
          end
        end
      end
    end
  end

  def department_json(department)
    Jbuilder.new do |jb|
      jb.id department.id
      jb.name department.name
      jb.n_members department.members.count
      jb.n_admins department.members.where({role: Employee::Roles[:admin]}).count
      jb.company department.company.name
      jb.set! :members do
        jb.array! department.members do |m|
          jb.name m.user.username
          jb.id m.id
          jb.salary m.salary
          jb.role m.role
          jb.company do
            jb.id = m.company.id
            jb.name m.company.name
          end 
          jb.department do
            jb.id m.department.id
            jb.name m.department.name
          end
        end
      end
    end
  end
  
end
