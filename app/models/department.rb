class Department < ApplicationRecord
  has_many :members, class_name: "Employee", dependent: :nullify

  validates :name, presence: true
end
