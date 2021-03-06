
<%# This template somehow overrides application standard template for all attachments! %>

<div class="attachments">
<div class="contextual">
  <%= link_to image_tag('edit.png'),
        container_attachments_edit_path(container),
        :title => l(:label_edit_attachments) if options[:editable] %>
</div>


<% for attachment in attachments %>

  <%# if viewing a kb article without hiding thumbs and not editing then hide 'thumbnail' attachments %>
<% if ( !defined?(@article) || ( @kb_use_thumbs && ( attachment.description != 'thumbnail' || @kb_article_editing ))) %>

<p>
<%= link_to_attachment attachment, :class => 'icon icon-attachment', :download => true -%>
  <% if attachment.is_text? %>
<%= link_to image_tag('magnifier.png'),
                :controller => 'attachments', :action => 'show',
  :id => attachment, :filename => attachment.filename %>
  <% end %>
<%= " - #{attachment.description}" unless attachment.description.blank? %>
  <span class="size">(<%= number_to_human_size attachment.filesize %>)</span>
  <% if options[:deletable] %>
    <%= link_to image_tag('delete.png'), attachment_path(attachment),
                :data => {:confirm => l(:text_are_you_sure)},
                :method => :delete,
                :class => 'delete',
                :title => l(:button_delete) %>
                <% end %>
    <% if options[:author] %>
    <span class="author"><%= attachment.author %>, <%= format_time(attachment.created_on) %></span>
  <% end %>

  <% end %>
  </p>
    <% end %>

    <%# Do not show thumbnail list for article attachments as it is just too confusing %>
<% unless defined?(@article) %>
 <% if defined?(thumbnails) && thumbnails %>
  <% images = attachments.select(&:thumbnailable?) %>
  <% if images.any? %>
  <div class="thumbnails">
    <% images.each do |attachment| %>
      <div><%= thumbnail_tag(attachment) %></div>
    <% end %>
  </div>
  <% end %>
 <% end %>
<% end %>

</div>
