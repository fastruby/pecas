module ApplicationHelper

  def users_active?
    current_page?(action: 'users') ||
      current_page?(root_url) ? raw(' class="active"') : ''
  end

  def projects_active?
    current_page?(action: 'projects') ? raw(' class="active"') : ''
  end
end
