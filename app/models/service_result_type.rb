class ServiceResultType < ActiveRecord::Base
  unloadable

  self.table_name = "service_result_types"

  validates_presence_of :name, :value_format
  attr_accessible :equipment_type_id, :service_type_id, :name, :value_format, :description

  belongs_to :equipment_type
  belongs_to :service_type
  has_many :serivces

  default_scope { order(name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def to_s
    name
  end
end