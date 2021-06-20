class TicketThread < ApplicationRecord
  belongs_to :ticket
  belongs_to :creator, polymorphic: true
  has_many_attached :attachments

  scope :thread_type, -> (t=1){where("thread_type = ?", t) }
  scope :thread_type_limit, -> (t=1){where("thread_type = ?", t).order(created_at: :desc).limit(1) }
  enum thread_type: { public_thread: 1, internal_thread: 2 }

  validates :body, presence: true

  after_commit :save_attachments

  def save_attachments_after_commit(attachments)
    @attachments = attachments
  end

  private

  def save_attachments
    attachments, @attachments = @attachments, nil
    self.attachments.attach(attachments) unless attachments.blank?
  end
end
