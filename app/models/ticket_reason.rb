class TicketReason < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort

  enum status: { disabled: 0, enabled: 1, deleted: 2 }

  validates :name, presence: true

  scope :active, -> { where.not(status: :deleted) }
  scope :current_default, -> { where(status: :enabled).find_by(default: 1) }
  scope :select_options, -> { where(status: :enabled).order(sort: :asc, created_at: :asc) }

  def soft_delete
    update(status: :deleted)
  end
end
