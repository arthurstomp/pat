require 'rails_helper'

RSpec.describe ApplicationPolicy do
  let(:user) { create(:user) }

  subject { described_class.new(user, user) }

  it "returns [] as scope" do
    resolved_scope = described_class::Scope.new(user, User).resolve
    expect(resolved_scope).to eq User.all
  end

  it { should_not permit(:index) }
  it { should_not permit(:show) }
  it { should_not permit(:create) }
  it { should_not permit(:new) }
  it { should_not permit(:update) }
  it { should_not permit(:edit) }
  it { should_not permit(:destroy) }
end
