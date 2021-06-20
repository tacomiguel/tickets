class User < ApplicationRecord
  include TokenAuthenticable
  has_many :tags, dependent: :destroy
  belongs_to :departament

  devise :database_authenticatable, :recoverable, :rememberable, :validatable#, :timeoutable

  scope :select_options, -> { where(deleted_at: nil) }

  before_save :set_name

  belongs_to :departament, optional: true

  def assign_departament(profile)
    return if profile.blank?
    departament = Departament.find_or_initialize_by(name: profile)
    update(departament_id: departament.id) if departament.save
  end

  def nickname
    return self.username if has_attribute?(:username)
    self.email.split('@').first
  end

  def active_for_authentication?
    super && !deleted?
  end

  def inactive_message
    !deleted? ? super : :deleted_account
  end

  def soft_delete
    update(deleted_at: Time.zone.now)
  end

  def deleted?
    deleted_at != nil
  end

  private

  def set_name
    self.name = self.email.split('@').first if self.name.nil?
  end
end
