class UnsubscribeClientJob < ApplicationJob
  sidekiq_options retry: 3
  queue_as :sync

  def perform(data)
    Geo::Utils::UnsubscribeClient.execute(data)
  end
end
