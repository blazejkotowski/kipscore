module LayoutHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context 
  
  def flash_major_notice_now(notice)
    flash.now[:info] = content_tag(:h3, notice)
  end
  
  def flash_major_notice(notice)
    flash[:info] = content_tag(:h3, notice)
  end
  
end
