Factory.define do
  define Employee do
    company
    department
    user
    name { Fake::RickAndMorty.character }
    role { "employee" }

    trait :admin do
      role { "administrator" }
    end
  end

  define User do
    sequence :email do |n|
      "user#{n}@test.com"
    end

    email
    username { Fake::RickAndMorty.character }
    employee
  end

  define Company do
    name { Fake::GameOfThrones.house }
  end

  define Department do
    name { Fake::GameOfThrones.house }
  end
end
