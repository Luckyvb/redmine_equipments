class DocumentType < ActiveRecord::Base
  unloadable

  self.table_name = "document_types"

  validates_presence_of :name, :description
  attr_accessible :name, :description

  has_many :consignment_notes

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