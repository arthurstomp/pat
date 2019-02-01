require 'rails_helper'

RSpec.describe CompanyPolicy do
  let(:user) { create(:user) }
  let(:company) { create(:company) }

  subject { described_class.new(user, company) }

  it "permits companies connected to user on scope" do
    user.owned_companies.create name: "test"
    someones_company = create :company
    create(:employee, company: someones_company, user: user)

    resolved_scope = described_class::Scope.new(user, Company.all).resolve

    expect(resolved_scope).to include(*user.owned_companies)
    expect(resolved_scope).to include(someones_company)
    
    total_of_companies = user.connected_to_companies.count
    expect(resolved_scope.count).to eq total_of_companies
  end

  it { should permit(:index) }

  it "permits :show user that connection to the company" do
    allow(user).to receive(:connected_to_companies).and_return([company])
    expect(subject).to permit_action(:show)
  end

  it { should_not permit(:show) }

  it { should permit(:create) }

  it "permits :update user that owns the company" do
    c = user.owned_companies.create name: "test"
    subject = described_class.new(user, c)
    expect(subject).to permit_action(:update)
  end
end
