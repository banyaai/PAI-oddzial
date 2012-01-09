module ApplicationHelper

  #Return a title on per-page basis.
  def title
    base_title = "Siec supermarketow"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag("logo.png", :alt => "Centrala App", :class => "round")
  end
end
