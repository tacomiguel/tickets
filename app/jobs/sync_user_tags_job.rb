class SyncUserTagsJob < ApplicationJob
  queue_as :default

  def perform(data)
    Geo::Utils::SyncUserTags.sync(data)
  end

  # def perform(user_id)
  #   user = User.find_by(id: user_id)
  #   return if user.nil?
  #   Geo::Utils::SyncUserTags.sync(user)
  # end
end
