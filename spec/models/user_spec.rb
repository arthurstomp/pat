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

  describe "#connected_to_companies" do
    subject { create :user }
    before :each do
      subject.owned_companies.create name: "Test!"
      someone_company = create(:company)
      someone_company.employees.create user: subject
    end

    it "should include owned_companies" do
      expect(subject.connected_to_companies).
        to include(*subject.owned_companies)
    end
    
    it "should include employee_of_companies" do
      expect(subject.connected_to_companies).
        to include(*subject.employee_of_companies)
    end

    it "count should be eq owned_companies + employee_of_companies" do
      owned_count = subject.owned_companies.count
      employee_count = subject.employee_of_companies.count
      expected_count = owned_count + employee_count
      expect(subject.connected_to_companies.count).to eq expected_count
    end
  end

  describe "#admin_and_owned_companies" do
    it "returns companies that are either owned or admin" do
      user = create :user
      c1 = create :company, user: user
      c2 = create :company
      c3 = create :company
      e = create :employee_admin, company: c2, user: user
      expect(user.admin_and_owned_companies).to include(c1)
      expect(user.admin_and_owned_companies).to include(c2)
      expect(user.admin_and_owned_companies).not_to include(c3)
    end
  end

  describe "#connected_to_departments" do
    subject { create :user }
    before :each do
      c = subject.owned_companies.create name: "Test!"
      d = c.departments.create name: "HR"
      someone_company = create(:company)
      sd = someone_company.departments.create name: "Dev"
      someone_company.employees.create user: subject, department: sd
    end

    it "should include owned_departments" do
      expect(subject.connected_to_departments).
        to include(*subject.owned_departments)
    end
    
    it "should include employee_of_departments" do
      expect(subject.connected_to_departments).
        to include(*subject.employee_of_departments)
    end

    it "count should be eq owned_departments + employee_of_departments" do
      owned_count = subject.owned_departments.count
      employee_count = subject.employee_of_departments.count
      expected_count = owned_count + employee_count
      expect(subject.connected_to_departments.count).to eq expected_count
    end
  end

  describe "#owner_of?" do
    subject { create :user }
    it { expect(subject.owner_of?(1)).to eq false }

    context "Company" do
      it "expect to return true" do
        c = subject.owned_companies.create(name: "Test")
        expect(subject.owner_of?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        expect(subject.owner_of?(c)).to eq false 
      end
    end

    context "Department" do
      it "expect to return true" do
        c = subject.owned_departments.create(name: "Test")
        expect(subject.owner_of?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:department)
        expect(subject.owner_of?(c)).to eq false 
      end
    end
  end

  describe "#admin?" do
    it { expect(subject.admin?).to eq false }

    it "returns true if user owns any company" do
      allow(subject).to receive(:owned_companies).and_return([1])
      expect(subject.admin?).to eq true
    end

    it "returns true if user is admin of any company" do
      allow(subject).to receive(:admin_of_companies).and_return([1])
      expect(subject.admin?).to eq true
    end

    it "returns true if user is admin of any department" do
      allow(subject).to receive(:admin_of_departments).and_return([1])
      expect(subject.admin?).to eq true
    end
  end

  describe "#admin_of?" do
    subject { create :user }
    it { expect(subject.admin_of?(1)).to eq false }

    context "Company" do
      it "expect to return true" do
        c = create(:company)
        e = create(:employee,
                   company: c,
                   user: subject,
                   role: Employee::Roles[:admin])
        expect(subject.admin_of?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        e = create(:employee,
                   company: c,
                   user: subject)
        expect(subject.admin_of?(c)).to eq false 
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
        expect(subject.admin_of?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        d = create(:department, company: c)
        e = create(:employee,
                   company: c,
                   department: d, 
                   user: subject)
        expect(subject.admin_of?(c)).to eq false 
      end
    end
  end

  describe "#member_of?" do
    subject { create :user }
    it { expect(subject.member_of?(1)).to eq false }

    context "Company" do
      it "expect to return true" do
        c = subject.owned_companies.create(name: "Test")
        expect(subject.member_of?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:company)
        expect(subject.member_of?(c)).to eq false 
      end
    end

    context "Department" do
      it "expect to return true" do
        c = subject.owned_departments.create(name: "Test")
        expect(subject.member_of?(c)).to eq true
      end

      it "expect to return false" do
        c = create(:department)
        expect(subject.member_of?(c)).to eq false 
      end
    end
  end

  describe "#claim" do
    subject { build :user }

    it "should return claim with email and username" do
      expect(subject.claim).to eq({email: subject.email, username: subject.username})
    end
  end

  describe "#jwt" do
    subject { build :user }

    it "returns the jwt for user claim" do
      expect(subject.jwt).to be_a String
    end
  end

  describe "#request_builder" do
    it { expect(subject.request_builder).to be_a FrontMakeup::User }
  end
end
