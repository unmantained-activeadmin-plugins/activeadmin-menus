module ActiveAdmin
  module Menus
    module Helpers
      def active_menu_item_attributes(active)
        active ? { class: 'active' } : {}
      end

      def active_link_to(active, label, link)
        link_to(label, link, active_menu_item_attributes(active))
      end

      def render_menu(area)
        menu = ::Menu.find_by_area(area)
        return "" unless menu.present?
        area_config = ActiveAdmin::Menus.area_config(area)
        children_html = menu.menu_items.roots.map do |item|
          render_menu_item(area_config, item)
        end.join.html_safe
        wrap_menu_items(nil, children_html, area_config)
      end

      def render_menu_item_subitems(area_config, item)
        return "" unless item.children.any?
        children_html = item.children.map do |item|
          render_menu_item(area_config, item)
        end.join.html_safe
        wrap_menu_items(item, children_html, area_config)
      end

      def render_menu_item(area_config, item)
        content_html = case item
        when PredefinedMenuItem
          render_predefined_menu_item(area_config, item)
        when CustomMenuItem
          render_custom_menu_item(area_config, item)
        when ResourceMenuItem
          render_resource_menu_item(area_config, item)
        end
      end

      def render_predefined_menu_item(area_config, item)
        config = ActiveAdmin::Menus.predefined_item_config(item.code)
        active = check_if_predefined_item_active(item, config)
        content_html = render_predefined_item(item, active, config) << render_menu_item_subitems(area_config, item)
        wrap_menu_item(item, active, content_html, area_config)
      end

      def render_custom_menu_item(area_config, item)
        content_html = render_custom_item(item, area_config) << render_menu_item_subitems(area_config, item)
        wrap_menu_item(item, false, content_html, area_config)
      end

      def render_resource_menu_item(area_config, item)
        config = ActiveAdmin::Menus.resource_class_config(item.resource_type)
        active = check_if_resource_item_active(item, config)
        content_html = render_resource_item(item, active, config) << render_menu_item_subitems(area_config, item)
        wrap_menu_item(item, active, content_html, area_config)
      end

      def wrap_menu_items(item, content, area_config)
        if area_config.list_wrapper.present?
          instance_exec_menu_block(content, nil, &area_config.list_wrapper)
        else
          content_tag(:ul, content)
        end
      end

      def wrap_menu_item(item, active, content, area_config)
        if area_config.item_wrapper.present?
          instance_exec_menu_block(content, active, item, &area_config.item_wrapper)
        else
          content_tag(:li, content, active_menu_item_attributes(active))
        end
      end

      def check_if_predefined_item_active(item, config)
        if config.active_if.present?
          instance_exec_menu_block(item, &config.active_if)
        else
          false
        end
      end

      def check_if_resource_item_active(item, config)
        if config.active_if.present?
          instance_exec_menu_block(item.resource, item, &config.active_if)
        else
          false
        end
      end

      def render_resource_item(item, active, config)
        if config.renderer.present?
          instance_exec_menu_block(item.resource, active, item, &config.renderer)
        else
          active_link_to active, item.resource, "#"
        end
      end

      def render_custom_item(item, area_config)
        if area_config.custom_item_renderer.present?
          instance_exec_menu_block(item, &area_config.custom_item_renderer)
        else
          link_to(item.label, item.url)
        end
      end

      def render_predefined_item(item, active, config)
        if config.renderer.present?
          instance_exec_menu_block(active, item, &config.renderer)
        else
          active_link_to active, item.code.titleize, "#"
        end
      end

      def instance_exec_menu_block(*args, &block)
        instance_exec *args[0...block.arity], &block
      end
    end
  end
end

