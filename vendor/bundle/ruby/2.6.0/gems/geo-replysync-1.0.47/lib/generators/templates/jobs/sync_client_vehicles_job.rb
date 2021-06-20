class SyncClientVehiclesJob < ApplicationJob
  sidekiq_options retry: 3
  queue_as :sync

  def perform(panel_user)
    Geo::Utils::SyncClientVehicles.sync(panel_user)
  end
end
