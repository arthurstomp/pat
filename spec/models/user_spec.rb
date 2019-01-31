require 'rails_helper'

RSpec.describe User, type: :model do
  it "should have many jobs" do
    should have_many(:jobs)
      .dependent(:destroy)
      .class_name("Employee")
  end

  it "should have many owned_companies" do
    should have_many(:owned_companies).
      class_name("Company").
      dependent(:destroy)
  end

  it "should have many owned_departments" do
    should have_many(:owned_departments).
      source(:departments).
      through(:owned_companies)
  end
  
  it "should have many employee_of_companies" do
    should have_many(:employee_of_companies).
      source(:company).
      through(:jobs)
  end

  it "should have many admin_of_companies" do
    should have_many(:admin_of_companies).
      conditions(employess: { role: Employee::Roles[:admin] }).
      source(:company).
      through(:jobs)
  end

  it "should have many employee_of_departments" do
    should have_many(:employee_of_departments).
      source(:department).
      through(:jobs)
  end

  it "should have many admin_of_departments" do
    should have_many(:admin_of_departments).
      conditions(employees: { role: Employee::Roles[:admin] }).
      source(:department).
      through(:jobs)
  end

  it { should validate_presence_of :email }
  it { should validate_presence_of :username }

  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :username }

  it { should allow_value(Faker::RickAndMorty.character).for(:username) }

  it { should allow_value("test@test.com").for(:email) }
  it { should_not allow_value("test").for(:email) }
  it { should_not allow_value("test@test").for(:email) }

  describe "#owner?" do
    subject { create :user }
    it { expect(subject.owner?(1)).to eq false }

    context "Company" do
      it "expect to return true" do
        c = subject.owned_companies.create(name: "Test")
        expect(subject.owner?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        expect(subject.owner?(c)).to eq false 
      end
    end

    context "Department" do
      it "expect to return true" do
        c = subject.owned_departments.create(name: "Test")
        expect(subject.owner?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:department)
        expect(subject.owner?(c)).to eq false 
      end
    end
  end

  describe "#admin?" do
    subject { create :user }
    it { expect(subject.admin?(1)).to eq false }

    context "Company" do
      it "expect to return true" do
        c = create(:company)
        e = create(:employee,
                   company: c,
                   user: subject,
                   role: Employee::Roles[:admin])
        expect(subject.admin?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        e = create(:employee,
                   company: c,
                   user: subject)
        expect(subject.admin?(c)).to eq false 
      end
    end

    context "Department" do
      it "expect to return true" do
        c = create(:company)
        d = create(:department, company: c)
        e = create(:employee,
                   company: c,
                   department: d, 
                   user: subject,
                   role: Employee::Roles[:admin])
        expect(subject.admin?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        d = create(:department, company: c)
        e = create(:employee,
                   company: c,
                   department: d, 
                   user: subject)
        expect(subject.admin?(c)).to eq false 
      end
    end
  end

  describe "#member?" do
    subject { create :user }
    it { expect(subject.member?(1)).to eq false }

    context "Company" do
      it "expect to return true" do
        c = subject.owned_companies.create(name: "Test")
        expect(subject.member?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        expect(subject.member?(c)).to eq false 
      end
    end

    context "Department" do
      it "expect to return true" do
        c = subject.owned_departments.create(name: "Test")
        expect(subject.member?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:department)
        expect(subject.member?(c)).to eq false 
      end
    end
  end

  describe "claim" do
    subject { build :user }

    it "should return claim with email and username" do
      expect(subject.claim).to eq({email: subject.email, username: subject.username})
    end
  end
end
