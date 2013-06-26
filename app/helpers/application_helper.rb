module ApplicationHelper

  def sidebar_logo_link
    path = '/main/index'
    default_class = 'btn btn-large btn-block notist-logo'
    class_name = default_class + (current_page?(path) ? ' active' : '')

    content_tag :li, :class do
      link_to '', path, :class => class_name
    end
  end

  def sidebar_link(text, path, icon_name)
    default_class = 'btn btn-large btn-block'
    class_name = default_class + (request.fullpath.starts_with?(path) ? ' active' : '')

    content_tag :li, :class do
      link_to path, :class => class_name do
        content_tag(:i, :class => icon_name) do
        end +
        content_tag(:div, :class => 'text') do
          text
        end
      end
    end
  end
end
