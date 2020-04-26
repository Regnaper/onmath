class TestsController < ApplicationController

  before_action :logged_in_user
  before_action :admin_user,     only: [:create, :edit, :update, :destroy]

  def index
    @tests = Test.paginate(page: params[:page])
    @user_results = Result.where(user_id: current_user)
    @test ||=  Test.new
  end

  def create
    @test = Test.create(params.require(:test).permit(:name))
    @test.theme = @test.subtheme = "Default"
    if @test.save
      flash[:success] = "Test created"
      redirect_to edit_test_path(@test)
    else
      @tests = Test.paginate(page: params[:page])
      @user_results = Result.where(user_id: current_user)
      render 'tests/index'
    end
  end

  def edit
    @test = Test.find(params[:id])
    @questions = @test.questions.order(:created_at)
    @question = @test.questions.new
  end

  def update
    @test = Test.find(params[:id])
    if @test.update_attributes(params.require(:test).permit(:name, :theme, :subtheme))
      flash[:success] = "Test updated"
      redirect_to tests_url
    else
      render 'edit'
    end
  end

  def destroy
    Test.find(params[:id]).destroy
    flash[:success] = "Test deleted"
    redirect_to tests_url
  end
end
