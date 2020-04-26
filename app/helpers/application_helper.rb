module ApplicationHelper

  # Возвращает полный заголовок на основе заголовка страницы.
  def full_title(page_title = '')
    base_title = "onMath.ru"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def show_room
    controller_name == 'rooms' and action_name == 'show' ? true : false
  end
end