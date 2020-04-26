require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    #assert_select 'input[type=file]'
    # Невалидная отправка формы.
    assert_difference 'Micropost.count', 0 do
      post microposts_path, params: { micropost: { content: "", picture: nil } }
    end
    # Валидная отправка формы.
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Удаление сообщения.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Посещение профиля другого пользователя.
    get user_path(users(:archer))
    assert_select 'a', text: 'delete'
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    # Пользователь без микросообщений
    other_user = users(:lana)
    log_in_as(other_user)
    get root_path
    other_user.microposts.create!(content: "A micropost")
    get root_path
  end
end