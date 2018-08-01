class Room < ApplicationRecord
  belongs_to :estimate
  has_many :items, dependent: :destroy, inverse_of: :room
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end
