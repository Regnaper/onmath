class UserMailer < ApplicationMailer

  default from: "iv_vod@mail.ru", 'Content-Transfer-Encoding' => '7bit'
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Welcome onMath.ru"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end