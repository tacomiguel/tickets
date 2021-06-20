class Departament < ApplicationRecord

  enum status: { disabled: 0, enabled: 1, deleted: 2 }
 
  validates :name, presence: true

  scope :active, -> { where.not(status: :deleted) }
  scope :select_options, -> { where(status: :enabled) }
  
   
  def soft_delete
    update(status: :deleted)
  end

 
end
