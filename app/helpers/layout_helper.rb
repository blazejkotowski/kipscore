module LayoutHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context 
  
  def flash_major_notice_now(notice)
    flash.now[:info] = content_tag(:h3, notice)
  end
  
  def flash_major_notice(notice)
    flash[:info] = content_tag(:h3, notice)
  end
  
  def popover_player_info(player_assoc)
    info = ''
    [:email, :phone, :licence, :comment].each do |attribute|
      value = player_assoc.try(attribute)
      info += content_tag(:p, value) if value.present?
    end    
    info == '' ? nil : info
  end
  
  def tooltip_attrs(key, attrs = {})
#    if attrs[:data].try("[]", :toggle).nil?
#      attrs[:data].merge!({:toggle => "tooltip"}) if attrs[:data].present?
#      attrs[:data] = {:toggle => "tooltip"} if attrs[:data].nil?
#    else
#      attrs[:data][:toggle] += " tooltip"
#    end
    
    if attrs[:class].nil?
      attrs[:class] = "tooltip-trigger"
    else
      attrs[:class] += " tooltip-trigger"
    end
    
    { :title => I18n.t("tooltips.#{key}") }.merge(attrs)
  end
  
end
