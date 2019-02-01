require 'faker'

FactoryBot.define do
  factory :employee do
    company
    department
    user
    role { "employee" }

    trait :admin do
      role { "administrator" }
    end

    factory :employee_admin, traits: [:admin]
  end

  factory :user do
    sequence :email do |n|
      "user#{n}@test.com"
    end
    sequence :username do |n|
      "user#{n}"
    end
  end

  factory :company do
    name { Faker::GameOfThrones.house }
    association :user, factory: :user
  end

  factory :department do
    name { Faker::GameOfThrones.house }
    association :company, factory: :company
  end
end
