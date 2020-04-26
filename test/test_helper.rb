ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper
  # Возвращает true, если тестовый пользователь осуществил вход.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Осуществляет вход тестового пользователя
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, params: { session: { email:       user.email,
                                            password:    password,
                                            remember_me: remember_me } }
    else
      session[:user_id] = user.id
    end
  end

  private

  # Возвращает true внутри интеграционных тестов
  def integration_test?
    defined?(post_via_redirect)
  end
end