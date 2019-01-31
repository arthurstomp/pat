require 'rails_helper'

RSpec.describe Employee, type: :model do
  it { should validate_presence_of :company_id }
  it { should validate_presence_of :department_id }
  it { should belong_to :company }
  it { should belong_to :department }
  it { should belong_to(:user).inverse_of(:jobs) }

  it { should allow_value(2_500.0).for(:salary) }

  describe "role validation" do
    it { should allow_value("administrator").for(:role) }
    it { should allow_value("employee").for(:role) }
    it { should_not allow_value("test").for(:role) }
  end

  describe "#admin?" do
    it "should return true" do
      subject = build :employee_admin
      expect(subject.admin?).to eq true 
    end
    it "should return false" do
      subject = build :employee
      expect(subject.admin?).to eq false
    end
  end
end
