module ApplicationHelper
  def auth_yammer_path
    '/auth/yammer'
  end

  def image_url(source)
    "#{root_url[0...-1]}#{image_path(source)}"
  end
end
