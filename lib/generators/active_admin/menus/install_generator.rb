module ActiveAdmin
  module Menus
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path("../templates", __FILE__)

        desc "Copies initializer."
        def copy_config_file
          copy_file "config.rb.erb", "app/admin/menus.rb"
        end

        desc "Copies migrations to your application."
        def copy_migrations
          rake("activeadmin_menus:install:migrations")
        end
      end
    end
  end
end

