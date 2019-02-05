require 'rails_helper'

RSpec.describe EmployeePolicy do
  let(:user) { create(:user) }
  let(:employee) { create(:employee) }

  subject { described_class.new(user, employee) }

  describe "Employee behavior" do

    before :each do
      allow(user).to receive(:admin?).and_return(false)
    end

    context "index?" do
      let(:resolved_scope) do
        described_class::Scope.new(user, Employee.all).resolve
      end

      it "should return [] if user isn't admin" do
        expect(resolved_scope).not_to include(user.jobs)
        expect(resolved_scope).to eq []
      end
    end

    context "show?" do
      it "should forbid if user isn't admin" do
        employee = create(:employee)
        subject = described_class.new(user, employee)
        expect(subject).not_to permit_action(:show)
      end

      it "should permit employee to see its own info" do
        user.jobs << create(:employee)
        subject = described_class.new(user, user.jobs.first)
        expect(subject).to permit_action(:show)
      end
    end

    context "create?" do
      it { should_not permit(:create) }
    end
  end

  describe "Administrator behavior" do
    let(:resolved_scope) { described_class::Scope.new(user, Employee.all).resolve }

    before :each do
      allow(user).to receive(:admin?).and_return(true)
    end

    context "index?" do
      subject { described_class.new(user, nil) }

      it { should permit(:index) }

      it "should return companies employees belong to user" do
        user.jobs << create(:employee)
        expect(resolved_scope.to_a).to eq(user.jobs.to_a)
      end
    end

    context "show?" do
      it "should permit if record belongs to user" do
        company = create(:company)
        employee = create(:employee, company: company, user: user)
        subject = described_class.new(user, employee)
        expect(subject).to permit_action(:show)
      end

      it "permits if record's company is admin by user" do
        company = create(:company, user: user)
        employee = create(:employee, company: company)
        subject = described_class.new(user, employee)
        expect(subject).to permit_action(:show)
      end
    end

    context "create?" do
      it { should permit(:create) }
    end
  end
end
