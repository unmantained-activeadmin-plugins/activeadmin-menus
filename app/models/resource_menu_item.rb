class ResourceMenuItem < MenuItem
  attr_accessible :resource, :resource_id, :resource_type
  belongs_to :resource, polymorphic: true
  validates :resource_type, presence: true
  validates :resource_id, presence: true
end

