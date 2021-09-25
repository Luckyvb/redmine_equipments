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

  def parent_options_for_select(parents,selected_id = nil)
    options_for_select(@parents.map { |p| ["#{'»' * p.depth} #{p.to_s}", p.id] }, selected_id)
  end

end

