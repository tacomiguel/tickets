# lib/generators/geo/replysync_generator.rb
require 'rails/generators/base'

module Geo
  module ViewPathReplysync
    extend ActiveSupport::Concern

    included do
      source_root File.expand_path("../templates", __dir__)
      public_task :copy_replysync_files
    end

    def copy_replysync_files
      copy_file "controllers/replysync_controller.rb", "app/controllers/replysync_controller.rb"
      copy_file "config/replysync.whitelist.yml", "config/replysync.whitelist.yml"
      route "post 'replysync', to: 'replysync#sync'"
      route "post 'replysync/unsubscribe-client', to: 'replysync#unsubscribe_client'"
      copy_file "jobs/sync_client_vehicles_job.rb", "app/jobs/sync_client_vehicles_job.rb"
      copy_file "jobs/unsubscribe_client_job.rb", "app/jobs/unsubscribe_client_job.rb"
    end

    protected
  end

  class ReplysyncGenerator < Rails::Generators::Base
    desc "Copies files of replysync to your application."
    include ViewPathReplysync
  end
end
