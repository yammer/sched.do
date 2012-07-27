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
end
