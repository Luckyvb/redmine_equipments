module EquipmentTypesHelper

  def equipment_type_options_for_select(selected = nil, disabled = nil)
    items = EquipmentType.arrange_serializable(:order => :name)
    "<options>#{ancestry_options(items, selected, disabled)}</options>".html_safe
  end

  def ancestry_options(items, selected = nil, disabled = nil, level=0)
    options = ''
    items.each do |e|
      s = " selected=\"selected\"" if !selected.blank? && selected == e['id']
      d = " disabled=\"disabled\"" if !disabled.blank? && disabled.to_i == e['id']
      options << "<option value=\"#{e['id']}\"#{s}#{d} class=\"options-group-lvl-#{level}\">#{e['name']}</option>"
      options << ancestry_options(e['children'], selected, disabled, level+1) if !e['children'].blank? && e['children'].any?
    end
    options
  end

  def tree(ignore=nil)
    ancestry_options2(EquipmentType.scoped.arrange(:order => 'name'), ignore) { |i|
      "#{'-' * i.depth} #{i.name}"
    }
  end

  def ancestry_options2(items, ignore)
    result = []
    items.map do |item, sub_items|
      result << [yield(item), item.id] unless item.id == ignore
      result += ancestry_options(sub_items, ignore) { |i|
        "#{'-' * i.depth} #{i.name}"
      }
    end
    result
  end

end