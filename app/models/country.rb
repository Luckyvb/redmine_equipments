class Country < ActiveRecord::Base
  unloadable

  self.table_name = "countries"

  validates_presence_of :name, :short_name, :iso
  attr_accessible :name, :short_name, :iso

  has_many :cities
  has_many :addresses, through: :cities
  has_many :floors, through: :addresses
  has_many :rooms, through: :floors
  has_many :equipments, through: :rooms

  default_scope { order(short_name: :asc, name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def to_s
    short_name.blank? ? name : "#{short_name} (#{name}, #{iso})"
  end
end