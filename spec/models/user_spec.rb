require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :username }

  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :username }

  it { should have_one :employee }
  
  it { should allow_value(Faker::RickAndMorty.character).for(:username) }

  it { should allow_value("test@test.com").for(:email) }
  it { should_not allow_value("test").for(:email) }
  it { should_not allow_value("test@test").for(:email) }
end
