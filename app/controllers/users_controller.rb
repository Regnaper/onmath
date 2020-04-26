class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: [:index, :destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and nil unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user.send_activation_email
        flash[:info] = "Пожалуйста, проверьте Вашу почту и перейдите по ссылке,
                        указанной в письме для активации аккаунта."
        redirect_to root_url
      else
        flash[:danger] = "Не удалось отправить сообщение с кодом активации на Ваш e-mail."
        @user.destroy
        @user = User.new
        render 'new'
      end
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    # Предфильтры

    # Подтверждает правильного пользователя
    def correct_user
      @user = User.find(params[:id])
      if current_user
        unless current_user?(@user) || current_user.admin?
          flash[:danger] = "Вы не имеете полномочий для просмотра этой страницы"
          redirect_to(root_url)
        end
      end
    end
end
