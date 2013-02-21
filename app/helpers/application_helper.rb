module ApplicationHelper
  def auth_yammer_path
    '/auth/yammer'
  end

  def image_url(source)
    root_url_without_trailing_slash + image_path(source)
  end

  def root_url_without_trailing_slash
    root_url[0...-1]
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'current' : ''

    content_tag(:li, class: :class_name) do
      link_to link_text, link_path
    end
  end
end
