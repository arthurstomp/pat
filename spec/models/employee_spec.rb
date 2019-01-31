require 'rails_helper'

RSpec.describe Employee, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :company_id }
  it { should validate_presence_of :department_id }
  it { should belong_to :company }
  it { should belong_to :department }

  it { should allow_value(Faker::RickAndMorty.character).for(:name) }
end
