class Menu < ActiveRecord::Base
  attr_accessible :name, :area
  self.table_name = "active_admin_menus"
  validates :name, presence: true
  validates :area, uniqueness: true

  has_many :menu_items
  has_many :resource_menu_items
  has_many :custom_menu_items
  has_many :predefined_menu_items

  def self.find_by_area(area)
    where(area: area.to_s).first
  end
end

