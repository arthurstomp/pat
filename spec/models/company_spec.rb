require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should have_many(:employees).dependent(:destroy) }
  it { should have_many(:departments).inverse_of(:company) }
  it { should belong_to(:user).class_name("User") }

  it { should allow_value(Faker::GameOfThrones.house).for(:name) }
  it { should validate_presence_of :name }

  describe "#job_of_user" do
    it "return jobs of user" do
      company = create :company
      user = create :user
      employee = create :employee, company: company, user: user
      expect(company.job_of_user(user).to_a).to eq([employee])
    end
  end

  describe "#user_is_admin?" do
    it "returns true if user is admin or owner" do
      user = create :user
      user2 = create :user
      company = create :company, user: user
      admin = create(:employee_admin, user: user2, company: company)
      expect(company.user_is_admin?(user)).to be true
      expect(company.user_is_admin?(user2)).to be true
    end
  end

  describe "#user_is_just_member?" do
    it "is the oposite of user_is_admin?" do
      user = create :user
      company = create :company
      allow(company).to receive(:user_is_admin?).with(user).and_return(false)
      expect(company.user_is_just_member?(user)).to be true
    end
  end
end
