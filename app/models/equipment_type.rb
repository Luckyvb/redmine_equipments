class EquipmentType < ActiveRecord::Base
  unloadable

  self.table_name = "equipment_types"

  validates_presence_of :name
  attr_accessible :parent_id, :name, :number_template

  has_ancestry
  acts_as_list scope: [:ancestry] # acts as list using

  has_many :vendor_models
  has_many :equipments, as: :owner
  has_many :vendors, through: :vendor_model

  #default_scope order: :position # so we need default order
  #default_scope { order("concat(ifnull(ancestry,id),'/',ifnull(position,ifnull(ancestry,0)))", name: :asc) }
  #default_scope { order(:ancestry, name: :asc) }
  #default_scope { order(:path, name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def self.fetch_children_for_roots(roots)
    unless roots.blank?
      condition = roots.select{|r|r.replies_count > 0}.collect{|r| "(ancestry like '#{r.id}%')"}.join(' or ')
      unless condition.blank?
        children = EquipmentType.scoped(:from => 'equipment_types FORCE INDEX (index_equipment_types_on_ancestry)', :conditions => condition).all
        roots.concat children
      end
    end
    roots
  end
end