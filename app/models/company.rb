class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  belongs_to :user, class_name: "User"
  has_many :departments, inverse_of: :company

  validates :name, presence: true
end
