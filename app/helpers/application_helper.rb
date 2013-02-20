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

end
