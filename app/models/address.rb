class Address < ActiveRecord::Base
  unloadable

  self.table_name = "addresses"

  validates_presence_of :street_id, :name
  attr_accessible :street_id, :name, :coordinates

  belongs_to :street
  has_many :floors
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
    street.blank? ? name : "#{street.to_s}, #{name}"
  end
end