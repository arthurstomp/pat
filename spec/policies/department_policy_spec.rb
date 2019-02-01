require 'rails_helper'

RSpec.describe DepartmentPolicy do
  let(:user) { create(:user) }
  let(:department) { create(:department) }

  subject { described_class.new(user, department) }

  it "permits departments connected to user on scope" do
    c = user.owned_companies.create name: "test"
    c.departments.create name: "dev"
    someones_department = create :department
    create(:employee, department: someones_department, user: user)

    resolved_scope = described_class::Scope.new(user, Department.all).resolve

    expect(resolved_scope).to include(*user.owned_departments)
    expect(resolved_scope).to include(someones_department)
    
    total_of_departments = user.connected_to_departments.count
    expect(resolved_scope.count).to eq total_of_departments
  end

  it { should permit(:index) }

  it "permits :show user that connection to the department" do
    allow(user).to receive(:connected_to_departments).and_return([department])
    expect(subject).to permit_action(:show)
  end

  it { should_not permit(:show) }

  it "permits if user owns any company" do
    allow(user).to receive(:owned_companies).and_return([1])
    expect(subject).to permit_action(:create)
  end

  it { should_not permit(:create) }

  it "permits :update user that owns the department" do
    c = user.owned_departments.create name: "test"
    subject = described_class.new(user, c)
    expect(subject).to permit_action(:update)
  end
end
