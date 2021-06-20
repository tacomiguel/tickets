# lib/generators/geo/replysync_generator.rb
require 'rails/generators/base'

module Geo
  module Utils
    module ViewPathInstall
      extend ActiveSupport::Concern
  
      included do
        source_root File.expand_path("../../templates", __dir__)
        public_task :copy_files
      end
  
      def copy_files
        copy_file "controllers/geoutils_controller.rb", "app/controllers/geoutils_controller.rb"
        copy_file "config/geo.utils.whitelist.yml", "config/geo.utils.whitelist.yml"
        route "post 'geoutils/sync', to: 'geoutils#sync'"
        generate "geo:utils:sync_user_tags"
      end
  
      protected
    end
  
    class InstallGenerator < Rails::Generators::Base
      desc ""
      include ViewPathInstall
    end
  end  
end
