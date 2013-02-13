module ApplicationHelper

  def sidebar_link(text, path, icon_name)
    class_name = current_page?(path) ? 'active' : ''

    content_tag :li, :class => class_name do
      link_to path do
        content_tag(:i, :class => icon_name) do
        end +
        content_tag(:span, :class => 'text') do
          text
        end
      end
    end
  end

end
