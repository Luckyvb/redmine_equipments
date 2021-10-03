include GlobalHelper

module LocationsHelper

  def location_controller_name(lt)
    case lt
    when "Country"
      'countries'
    when "City"
      'cities'
    when "Address"
      lt.downcase+'es'
    else
      lt.downcase+'s'
    end
  end

  def parent_options_for_select(parents, selected_id = nil, css = nil)
    options_for_select(@parents.map { |p| ["#{'»' * p.depth} #{p.to_s}", p.id, :class => css] }, selected_id)
  end

  def location_type_icon(lt)
    icon = "question"
    case lt.downcase
    when "country"
      icon = "globe"
    when "city"
      icon = "city"
    when "street"
      icon = "map-marked"
    when "address"
      icon = "building"
    when "floor"
      icon = "cubes"
    when "room"
      icon = "cube"
    end
    "fas fa-#{icon}"
  end
  def link_to_location_type(e)
    lt = e.location_type
    icon = location_type_icon(lt)
    link_to tag.i(:class => icon), {:controller => location_controller_name(lt), :action => 'index'}, :title => t(lt.downcase+'.title',count:1) unless lt.blank?
  end
  def link_to_location(e)
    lt = e.location_type
    id = e.location_id
    l = e.location
    link_to (l.blank? ? id : l.name), {:controller => location_controller_name(lt), :action => 'show', :id => id}, :title => l.to_s unless lt.blank?
  end

  def path_back_or_default
    base_path_back_or_default('locations')
  end

end

