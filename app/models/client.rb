class Client < ApplicationRecord
  enum client_type: { client: 1, user: 2 }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  scope :select_options, -> { order(name: :asc) }


end
