require_dependency "talking_stick/application_controller"

class StaticPagesController < ApplicationController
  include TalkingStick
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @room = TalkingStick::Room.find_not_create(slug: current_user.name)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end