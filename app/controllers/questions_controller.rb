class QuestionsController < ApplicationController

  def create
    @test = Test.find(params[:test])
    @questions = @test.questions.order(:created_at)
    @question = @test.questions.build(params.require(:question).permit(:question))
    @question.right_answer = 1
    if @question.save
      flash[:success] = "Question created"
      redirect_to edit_question_url(@question)
    else
      render 'tests/edit'
    end
  end

  def edit
    @question = Question.find(params[:id])
    @answers = @question.answers.order(:created_at)
    @answer = @question.answers.new
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params.require(:question).permit(:question, :right_answer))
      flash[:success] = "Question updated"
      redirect_to edit_test_url(@question.test)
    else
      render 'edit'
    end
  end

  def destroy
    question =  Question.find(params[:id])
    test = question.test
    question.destroy
    flash[:success] = "Answer deleted"
    redirect_to edit_test_url(test)
  end
end