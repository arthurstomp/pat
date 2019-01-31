require 'rails_helper'

RSpec.describe Employee, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :company_id }
  it { should validate_presence_of :department_id }
  it { should belong_to :company }
  it { should belong_to :department }
  it { should belong_to :user }

  it { should allow_value(Faker::RickAndMorty.character).for(:name) }

  it { should allow_value("administrator").for(:role) }
  it { should allow_value("employee").for(:role) }
  it { should_not allow_value("test").for(:role) }
end
