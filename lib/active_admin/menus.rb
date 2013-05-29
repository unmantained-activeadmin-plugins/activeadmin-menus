require 'active_admin/menus/engine'

module ActiveAdmin
  module Menus
    mattr_accessor :predefined_items
    mattr_accessor :resource_items
    mattr_accessor :areas

    def self.configure
      @@predefined_items = []
      @@resource_items = []
      @@areas = []
      yield self
    end

    def self.add_area(code)
      config = OpenStruct.new(code: code)
      yield config if block_given?
      @@areas << config
    end

    def self.add_predefined_item(code)
      config = OpenStruct.new(code: code)
      yield config if block_given?
      @@predefined_items << config
    end

    def self.add_resource_class(model)
      config = OpenStruct.new(model: model)
      yield config if block_given?
      @@resource_items << config
    end

    def self.area_codes
      @@areas.map(&:code)
    end

    def self.resource_classes
      @@resource_items.map(&:model)
    end

    def self.collection_for_resource_class(klass)
      config = resource_class_config(klass)
      return [] if config.nil?

      if config.collection.respond_to? :call
        config.collection.call
      else
        klass = klass.constantize unless klass.is_a?(Class)
        klass.send(config.collection || :all)
      end
    end

    def self.resource_class_config(klass)
      klass = klass.name if klass.is_a?(Class)
      @@resource_items.find do |config|
        model = config.model.is_a?(Class) ? config.model.name : config.model
        model == klass
      end
    end

    def self.predefined_item_config(code)
      @@predefined_items.find do |config|
        config.code.to_s == code.to_s
      end
    end

    def self.area_config(code)
      @@areas.find do |config|
        config.code.to_s == code.to_s
      end
    end
  end
end

