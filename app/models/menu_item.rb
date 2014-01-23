class MenuItem < ActiveRecord::Base
  self.table_name = "active_admin_menu_items"

  has_ancestry orphan_strategy: :rootify

  belongs_to :menu
  validate :menu, presence: true

  default_scope order(:position)
end

