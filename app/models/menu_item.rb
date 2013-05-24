class MenuItem < ActiveRecord::Base
  self.table_name = "active_admin_menu_items"
  attr_accessible :position, :menu, :parent, :parent_id

  has_ancestry orphan_strategy: :rootify

  belongs_to :menu
  validate :menu, presence: true

  default_scope order(:position)
end

