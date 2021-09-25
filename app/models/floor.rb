class Floor < ActiveRecord::Base
  unloadable

  self.table_name = "floors"

  validates_presence_of :address_id, :number
  attr_accessible :address_id, :number, :name

  belongs_to :address
  has_many :rooms
  has_many :equipments, through: :room

  default_scope { order(:address_id, :number) }
  #default_scope { include(:address).order('address.name asc', :number) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def to_s_short
    address.blank? ? "#{name}" : "#{address.to_s}, #{name}"
  end

  def to_s
    address.blank? ? "#{name} (#{number})" : "#{address.to_s}, #{name} (#{number})"
  end
end