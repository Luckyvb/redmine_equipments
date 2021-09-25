class Attribute < ActiveRecord::Base
  unloadable

  self.table_name = "attributes"

  validates_presence_of :name
  attr_accessible :name, :description

  has_many :attribute_values
  #has_many :equipments
  #has_many :vendor_models

  default_scope { order(name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }
end