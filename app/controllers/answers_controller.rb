class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question])
    @answers = @question.answers.order(:created_at)
    @answer = @question.answers.build(params.require(:answer).permit(:answer))
    if @answer.save
      flash[:success] = "Answer created"
      redirect_to edit_question_url(@question)
    else
      render 'questions/edit'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    question = answer.question
    answer.destroy
    flash[:success] = "Answer deleted"
    redirect_to edit_question_url(question)
  end
end
