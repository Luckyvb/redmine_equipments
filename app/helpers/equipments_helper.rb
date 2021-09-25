include LocationsHelper

module EquipmentsHelper

  def owner_controller_name(e)
    e.owner_type.downcase+'s'
  end

  def equipment_type_options_for_select(selected_id = nil)
    et = EquipmentType.arrange_serializable(:order => :name)

    "<options>#{fill_options_select_children(et, selected_id)}</options>".html_safe
    #ta = EquipmentType.arrange(:order => :name)
    #"<options>#{fill_range_options_select_children(eta)}</options>"
  end

  def fill_options_select_children(elements, selected_id = nil, level=0)
    options = ''
    elements.each do |e|
        if !e['children'].blank? && e['children'].any?
          options << "<optgroup label=\"#{'&nbsp;&nbsp;&nbsp;' * level}#{e['name']}\">"
          options << fill_options_select_children(e['children'], selected_id, level+1)
          options << "</optgroup>"
        else
          s = " selected=\"selected\"" if !selected_id.blank? && selected_id == e['id']
          options << "<option value=\"#{e['id']}\"#{s}>#{'&nbsp;' * level}#{e['name']}</option>"
        end
    end
    options
  end

  def fill_range_options_select_children(elements)
    options = ''
    elements.each do |e|
        if !elements[].blank? && e[].any?
          options << "<optgroup label=\"#{e.name}\">"
          options << fill_options_select_children(e[])
          options << "</optgroup>"
        else
          options << "<option value=\"#{e.id}\">#{e.name}</option>"
        end
        Rails.logger.info options
    end
    options
  end

  def path_back_or_default
    session[:return_to] || {:controller => 'equipments', :action => 'index', :project_id => @equipment.project[:identifier]}
  end

end
