class City < ActiveRecord::Base
  unloadable

  self.table_name = "cities"

  validates_presence_of :country_id, :name
  attr_accessible :country_id, :name

  belongs_to :country
  has_many :addresses
  has_many :floors, through: :addresses
  has_many :rooms, through: :floors
  has_many :equipments, through: :rooms

  default_scope { order(name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def to_s
    country.blank? ? name : "#{country.short_name}, #{name}"
  end
end