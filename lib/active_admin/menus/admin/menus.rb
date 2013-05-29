module MenuItemHelper
  def name_for_item(item)
    if item.is_a?(CustomMenuItem)
      item.label
    elsif item.is_a?(ResourceMenuItem)
      display_name(item.resource)
    elsif item.is_a?(PredefinedMenuItem)
      predefined_item_name(item)
    end
  end

  def area_name(area)
    I18n.t("menu_areas.#{area}", default: area.to_s.titleize)
  end

  def predefined_item_name(item)
    I18n.t("predefined_menu_items.#{item.code}", default: item.code.to_s.titleize)
  end

  def areas_collection
   ActiveAdmin::Menus.area_codes.map do |area|
     [ area_name(area), area ]
   end
  end

  def predefined_items_collection
     ActiveAdmin::Menus.predefined_items.map do |item|
       [ predefined_item_name(item), item.code ]
     end
  end

  def menu_item_collection(items)
    collection_tree(nil, items.roots)
  end

  def collection_tree(root, roots = nil)
    (root.present? ? root.children : roots).inject([]) do |x, r|
      x << [ "#{"--" * (r.depth + 1)} #{name_for_item(r)}", r.id ]
      x += collection_tree(r)
    end
  end
end

ActiveAdmin.register Menu do
  controller do
    helper MenuItemHelper

    def show
      redirect_to admin_menu_menu_items_path(resource)
    end
  end

  index do
    column :name
    column :area do |menu|
      area_name(menu.area)
    end
    column do |menu|
      link_to I18n.t('activeadmin.menus.edit_items'), admin_menu_menu_items_path(menu)
    end
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :area, collection: areas_collection
    end
    f.actions
  end
end

ActiveAdmin.register MenuItem do
  sortable tree: true, sort_url: ->(c) { c.sort_admin_menu_menu_items_path }
  belongs_to :menu
  actions :show, :edit, :index, :destroy

  controller do
    helper MenuItemHelper

    def show
      menu = Menu.find(params[:menu_id])
      redirect_to [:edit, :admin, menu, resource]
    end
    alias_method :edit, :show
  end

  config.clear_action_items!

  action_item do
    menu = Menu.find(params[:menu_id])
    [
      content_tag(:span, I18n.t('activeadmin.menus.add_new_item')),
      link_to(I18n.t("activeadmin.menus.new_predefined"), new_admin_menu_predefined_menu_item_path(menu)),
      link_to(I18n.t("activeadmin.menus.new_resource"), new_admin_menu_resource_menu_item_path(menu)),
      link_to(I18n.t("activeadmin.menus.new_custom"), new_admin_menu_custom_menu_item_path(menu))
    ].join(" ").html_safe
  end

  index as: :sortable do
    label do |item|
      name_for_item(item)
    end
    default_actions
  end
end

ActiveAdmin.register ResourceMenuItem do
  belongs_to :menu
  actions :index, :show, :new, :create, :edit, :update

  controller do
    helper MenuItemHelper

    def index
      redirect_to [:admin, parent, :menu_items]
    end
    alias_method :show, :index
  end

  form do |f|
    resources = if f.object.resource_type.present?
                  ActiveAdmin::Menus.collection_for_resource_class(f.object.resource_type)
                else
                  []
                end
    f.inputs I18n.t('activeadmin.menus.details') do
      f.input :parent_id, collection: menu_item_collection(f.object.menu.menu_items)
      f.input :resource_type, collection: ActiveAdmin::Menus.resource_classes
      f.input :resource_id, as: :select, collection: resources
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_menu_menu_items_path(f.object.menu))
    end
  end
end

ActiveAdmin.register PredefinedMenuItem do
  belongs_to :menu
  actions :index, :show, :new, :create, :edit, :update

  controller do
    helper MenuItemHelper

    def index
      redirect_to [:admin, parent, :menu_items]
    end
    alias_method :show, :index
  end

  form do |f|
    f.inputs I18n.t('activeadmin.menus.details') do
      f.input :parent_id, collection: menu_item_collection(f.object.menu.menu_items)
      f.input :code, collection: predefined_items_collection
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_menu_menu_items_path(f.object.menu))
    end
  end
end

ActiveAdmin.register CustomMenuItem do
  belongs_to :menu
  actions :index, :show, :new, :create, :edit, :update

  controller do
    helper MenuItemHelper

    def index
      redirect_to [:admin, parent, :menu_items]
    end
    alias_method :show, :index
  end

  form do |f|
    f.inputs I18n.t('activeadmin.menus.details') do
      f.input :parent_id, collection: menu_item_collection(f.object.menu.menu_items)
    end
    f.translated_inputs I18n.t('activeadmin.menus.link_details'), switch_locale: false do |t|
      t.input :label
      t.input :url, as: :string
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_menu_menu_items_path(f.object.menu))
    end
  end
end


