class ResourceMenuItem < MenuItem
  belongs_to :resource, polymorphic: true
  validates :resource_type, presence: true
  validates :resource_id, presence: true
end

