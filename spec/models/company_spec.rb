require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should have_many(:employees).dependent(:destroy) }
  it { should have_many(:departments).inverse_of(:company) }
  it { should belong_to(:user).class_name("User") }

  it { should allow_value(Faker::GameOfThrones.house).for(:name) }
  it { should validate_presence_of :name }
end
