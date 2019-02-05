require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { create(:user) }

  subject { described_class.new(user, user) }

  it "returns [] as scope" do
    resolved_scope = described_class::Scope.new(user, User).resolve
    expect(resolved_scope).to eq User.all
  end

  it { should permit(:login) }
  it { should permit(:show) }
  it { should permit(:create) }
end
