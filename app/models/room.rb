class Room < ActiveRecord::Base
  unloadable

  self.table_name = "rooms"

  validates_presence_of :floor_id, :number
  attr_accessible :floor_id, :number, :name

  belongs_to :floor
  has_many :equipments
  has_many :room_tenants
  has_many :organizations, through: :room_tenants

  delegate :address, :to => :floor, :allow_nil => false
  #default_scope { order(:floor_id, :number) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def to_s_short
    floor.blank? ? "#{name} (#{number})" : "#{floor.to_s_short}, #{name} (#{number})"
  end

  def to_s
    floor.blank? ? "#{name} (#{number})" : "#{floor.to_s}, #{name} (#{number})"
  end
end