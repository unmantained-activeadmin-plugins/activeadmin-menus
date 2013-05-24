class CreateActiveAdminMenus < ActiveRecord::Migration
  def migrate(direction)
    super
    if direction == :up
      ActiveAdmin::Menus::CustomMenuItem.create_translation_table! label: :string, url: :text
    else
      ActiveAdmin::Menus::CustomMenuItem.drop_translation_table!
    end
  end

  def change
    create_table :active_admin_menus do |t|
      t.string :name
      t.string :area
      t.timestamps
    end

    create_table :active_admin_menu_items do |t|
      t.integer :menu_id
      t.string :ancestry
      t.string :type
      t.integer :position
      t.timestamps

      # predefined links
      t.string :code

      # resource link
      t.integer :resource_id
      t.string :resource_type
    end

    add_index :active_admin_menu_items, :ancestry
  end
end

