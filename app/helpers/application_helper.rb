module ApplicationHelper

  def users_active_class
    current_page?(action: 'users') || current_page?(root_url) ? "active" : ""
  end

  def projects_active_class
    current_page?(action: 'projects') ? "active" : ""
  end
end
