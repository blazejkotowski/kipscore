module LayoutHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context 
  
  def flash_major_notice(notice)
    flash.now[:info] = content_tag(:h3, notice)
  end
  
end
