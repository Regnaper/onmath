require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @question = Question.new(question: "Вопрос", right_answer: 3)
  end

  test "should be valid" do
    assert @question.valid?
  end

  test "question should be present" do
    @question.question = "     "
    assert_not @question.valid?
  end

  test "right answer should be present" do
    @question.right_answer = "     "
    assert_not @question.valid?
  end

  test "right answer should be integer" do
    @question.right_answer = "three"
    assert_not @question.valid?
  end
end
