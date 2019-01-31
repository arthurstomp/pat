require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should validate_presence_of :name }
  it { should have_many :members }
  it { should allow_value(Faker::GameOfThrones.house).for(:name) }
end
