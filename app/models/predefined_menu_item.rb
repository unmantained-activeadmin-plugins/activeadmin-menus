class PredefinedMenuItem < MenuItem
  attr_accessible :code
  validates :code, presence: true
end

