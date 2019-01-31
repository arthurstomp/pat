class Department < ApplicationRecord
  has_many :members, class_name: "Employee", dependent: :nullify
  belongs_to :company, dependent: :destroy

  validates :name, presence: true
end
