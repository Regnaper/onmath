require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @active_user = users(:archer)
    @nonactive_user = users(:malory)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'img.gravatar'
  end

  test "show user information" do
    get user_path(@active_user)
    assert_not flash.empty?
    assert_redirected_to login_url
    #Переход на страницу неактивированного пользователя
    get user_path(@nonactive_user)
    assert_redirected_to login_url
    assert_select 'h1', text:@nonactive_user.name, count: 0
  end
end