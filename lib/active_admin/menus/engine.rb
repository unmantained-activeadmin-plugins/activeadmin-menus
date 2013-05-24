require 'ancestry'
require 'active_admin/menus/helpers'

module ActiveAdmin
  module Menus
    class Engine < ::Rails::Engine
      isolate_namespace ActiveAdmin::Menus
      engine_name 'activeadmin_menus'

      initializer "register resource" do
        ActiveAdmin.application.load_paths += [ File.expand_path('./admin', File.dirname(__FILE__)) ]
      end

      initializer "add helper" do |app|
        ActionView::Base.send :include, ActiveAdmin::Menus::Helpers
      end
    end
  end
end

