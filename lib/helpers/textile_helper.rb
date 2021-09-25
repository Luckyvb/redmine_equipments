# encoding: utf-8
require 'redmine'

module Equipments_textile
  def heads_for_wiki_formatter
    super
    unless @heads_for_wiki_formatter_with_equipments_included
      # This code is executed only once and inserts a javascript code
      # that patches the jsToolBar adding the new buttons.
      # After that, all editors in the page will get the new buttons.
      content_for :header_tags do
        javascript_tag 'if(typeof(Equipments) !== "undefined") Equipments.initToolbar();'
      end
      @heads_for_wiki_formatter_with_equipments_included = true
    end
  end
end

module Redmine::WikiFormatting::Textile::Helper
  prepend Equipments_textile
end
# end
