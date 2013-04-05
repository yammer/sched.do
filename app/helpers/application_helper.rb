module ApplicationHelper
  def yammer_assets_host
    if current_user.yammer_staging
      Rails.configuration.yammer_assets_staging_host
    else
      Rails.configuration.yammer_assets_host
    end
  end

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

  def terms_of_service_link
    link_to 'Terms of service',
      "#{Rails.configuration.yammer_host}/about/terms/",
      target: '_blank'
  end
end
