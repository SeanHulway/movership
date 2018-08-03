class Build < ApplicationRecord
  before_validation :set_uuid, on: :create
  validates :id, presence: true

  has_many :rooms, dependent: :destroy, inverse_of: :build
  has_many :items, through: :rooms

  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
    message: "Enter a valid email" }
  validates :phone, presence: true
  validates :name, presence: true
  
  accepts_nested_attributes_for :rooms, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def set_uuid
    self.id = SecureRandom.uuid
  end
end
