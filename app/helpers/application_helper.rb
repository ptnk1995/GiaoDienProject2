module ApplicationHelper

  def full_title page_title = ""
    base_title = t "project_name"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def display_image book, class_image = ""
    if book.image?
      image_tag book.image, class: class_image
    else
      image_tag "book1.jpg", class: class_image
    end
  end
end
