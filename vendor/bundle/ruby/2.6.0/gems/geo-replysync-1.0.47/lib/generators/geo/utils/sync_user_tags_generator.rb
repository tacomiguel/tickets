# lib/generators/geo/replysync_generator.rb
require 'rails/generators/base'

module Geo
  module Utils
    module ViewPathSyncUserTags
      extend ActiveSupport::Concern
  
      included do
        source_root File.expand_path("../../templates", __dir__)
        public_task :copy_files
      end
  
      def copy_files
        copy_file "jobs/sync_user_tags_job.rb", "app/jobs/sync_user_tags_job.rb"
        # inject_into_file 'app/models/user.rb', %q{
        #   after_commit on: [:create, :update] do
        #     SyncUserTagsJob.perform_later(self.id)
        #   end
        # }, after: 'class User < ApplicationRecord'
      end
  
      protected
    end
  
    class SyncUserTagsGenerator < Rails::Generators::Base
      desc ""
      include ViewPathSyncUserTags
    end
  end  
end
