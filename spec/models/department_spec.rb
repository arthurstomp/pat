require 'rails_helper'

RSpec.describe Department, type: :model do
  it { should have_many(:members).
       dependent(:nullify).
       class_name("Employee") }

  it { should belong_to(:company).dependent(:destroy) }
  
  it { should allow_value(Faker::GameOfThrones.house).for(:name) }
  it { should validate_presence_of :name }
end
