class Department < ApplicationRecord
  default_scope { order(created_at: :desc) }

  has_many :members, class_name: "Employee", dependent: :nullify
  belongs_to :company, dependent: :destroy

  validates :name, presence: true
end
