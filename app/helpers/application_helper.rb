module ApplicationHelper

  def sidebar_link(text, path, icon_name)
    default_class = 'btn btn-large btn-block btn-info'
    class_name = default_class + (current_page?(path) ? ' active' : '')

    content_tag :li, :class do
      link_to path, :class => class_name do
        content_tag(:i, :class => icon_name + ' icon-white') do
        end +
        content_tag(:span, :class => 'text') do
          text
        end
      end
    end
  end

end
