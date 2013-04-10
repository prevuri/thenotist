module UiHelper

  def checkbox(label, id, className, defaultOn)
    classes = 'checkbox' + (defaultOn ? ' checked' : '')
    if className
      classes += ' ' + className
    end

    content_tag(:label,
      content_tag(:input, '', :type => 'checkbox', :id => id) + label,
      :class => classes, :for => id)
  end

end
