class EmployeesController < ApplicationController
  include Pundit

  wrap_parameters format: [:json]

  before_action :authenticate

  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: :index

  def index
    jobs = policy_scope(Employee.all)
    render json: {jobs: index_json(jobs).target!}
  end

  def show
    job = Employee.find(params[:id])
    authorize(job)
    render json: {job: show_json(job).target!,
                  can_update: job.company.user_is_admin?(current_user) }
  end

  def update
    job = Employee.find(params[:id])
    authorize(job)
    if job.update_attributes(employee_params) 
      render json: {job: show_json(job).target!,
                    can_update: job.company.user_is_admin?(current_user) }
    else
      render json: job.errors.full_messages, status: 400
    end
  end

  def create
    job = Employee.new(employee_params)
    authorize(job)
    if job.save
      render json: {job: show_json(job).target!,
                    can_update: job.company.user_is_admin?(current_user)}
    else
      render json: job.errors.full_messages, status: 400
    end
  end

  private

  def employee_params
    params.require(:job).permit([:name,:user_id, :company_id, :department_id, :salary, :role])
  end

  def index_json(jobs)
    json = Jbuilder.new do |jb|
      jb.array! jobs do |j|
        jb.id j.id
        jb.role j.role
        jb.set! :user do
          jb.id j.user.id
          jb.username j.user.username
          jb.email j.user.email
        end
        jb.set! :company do
          jb.id j.company.id
          jb.name j.company.name
          jb.set! :departments do
            jb.array j.company.departments do |d|
              jb.id d.id
              jb.name d.name
            end
          end
        end
        jb.set! :department do
          jb.id j.department.id
          jb.name j.department.name
        end
        jb.salary j.salary
      end
    end
  end

  def show_json(job)
    json = Jbuilder.new do |jb|
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
