module ApplicationHelper
  def full_page_title(title)
    main_part = "Kipscore"
    if title.empty?
      main_part
    else
      "#{title} | #{main_part}"
    end
  end
end
