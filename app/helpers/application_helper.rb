module ApplicationHelper
  def full_page_title(title)
    main_part = "Kipscore"
    if title.empty?
      main_part
    else
      "#{title} | #{main_part}"
    end
  end
  
  def haml_tag_if(condition, *args, &block)
    if condition
      haml_tag *args, &block
     else
       yield
     end
  end
  
  def current_uri
    "#{request.protocol}#{request.host_with_port}#{request.path}"
  end
  
  def sport_options
    Sport.all.map { |s| [s.name, s.id] }
  end
  
  # Devise fucked helpers
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def resource_class
    devise_mapping.to
  end
  
  def authenticate_admin!
    redirect_to root_path unless current_user.admin?
  end
  
end
