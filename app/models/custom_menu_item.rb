class CustomMenuItem < MenuItem
  active_admin_translates :label, :url do
    validates :label, :url, presence: true
  end
end

