class ResultsController < ApplicationController

  def show
    @result = Result.find(params[:id])
    @test = @result.test
    @questions = @test.questions
    @right_answers_count = right_answer_count(@questions, @result)
    @percent = percent(@test, @result)
  end

  def new
    @test = Test.find(params[:id])
    @users = User.where(activated: true).all
    @result = Result.new
  end

  def create
    @test = Test.find(params[:id])
    @users = User.where(activated: true).all
    @result = Result.new
    $error = false
    if params[:users] == NIL
      $error = true
      flash[:danger] = "Вы не назначили тест ни одному пользователю"
      render 'new'
    else
      users = params[:users].to_unsafe_hash.map{ |key, value| key if value == "checked"}
      users.each do |user_id|
        @result = Result.new(user_id: user_id.to_i,
                       test_id: params[:id],
                       attempt_count: params[:attempt_count][user_id].to_i,
                       pass_time: params[:pass_time][user_id].to_i * 60)
        unless @result.save
          @result = Result.find_by(user_id: user_id.to_i, test_id: params[:id])
          unless @result && @result.update_attributes(attempt_count: params[:attempt_count][user_id].to_i,
                                    pass_time: params[:pass_time][user_id].to_i * 60)
            $error = true
            flash[:danger] = "Что-то пошло не так. Попробуйте еще раз."
          end
        end
      end
      if $error
        redirect_to new_result_path(id: params[:id])
      else
        flash[:success] = "Тест назначен пользователям"
        redirect_to tests_path
      end
    end
  end

  def edit
    @test = Test.find(params[:id])
    @result = @test.results.find_by(user_id: current_user.id)
    @pass_time = @result.pass_time
    if @result.attempt_count < 1
      flash[:danger] = @result.attempt_count == 0 ? "Закончились попытки" : "Вы уже прошли тест"
      redirect_to tests_path
    end
    @result.attempt_count -= 1 if @result.attempt_count > 0
    @result.save
  end

  def update
    @test = Test.find(params[:test_id])
    @result = @test.results.find_by(user_id: current_user.id)
    @pass_time = params[:passed_time].to_i
    user_id = current_user.id
    test_id = @test.id
    results = results(@test)
    if results.include?(nil)
      flash[:danger] = "Вы ответили не на все вопросы!"
      render 'edit' and nil
    elsif @result.update_attributes(user_id: user_id,
                                    test_id: test_id,
                                    results: results)
      flash[:success] = "Результат принят. Осталось попыток: #{@result.attempt_count}"
      if percent(@test, @result) >= 70
        pass_test_post(current_user, @test, @result)
        @result.attempt_count = -1
        @result.save
      end
      redirect_to result_path(@result)
    else
      flash[:danger] = @result.errors.full_messages.join(".\n")
      redirect_to tests_path
    end
  end

  private

    def pass_test_post(user, test, result)
      link = view_context.link_to("Результат здесь.", result_path(result))
      user.microposts.create!(content: "Мной был пройден тест: \"#{test.name}\". #{link}")
    end

    def right_answer_count(questions, result)
      right_answers_count = 0
      questions.each_with_index do |question, index|
        if question.answers.length == 1
          answer = result.results[index][:answer]
        else
          answer = question.answers[result.results[index].to_i].answer
        end
        right_answer = question.answers[question.right_answer-1].answer
        right_answers_count += 1 if right_answer == answer
      end
      right_answers_count
    end

    def percent(test, result)
      right = right_answer_count(test.questions, result)
      right.to_f*100 / test.questions.length
    end

    def results(test)
      results = []
      test.questions.each_with_index do |question, index|
        if question.answers.length == 1
          result = params[:"#{index}"].blank? ? nil : params[:"#{index}"]
          results[index] = result ? { :answer => result } : nil
        else
          results[index] = params[:"#{index}"] || nil
        end
      end
      results
    end
end