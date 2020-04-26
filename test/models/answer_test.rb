require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  def setup
    @answer = Answer.create!(answer: 'Миллион')
  end

  test "should be valid" do
    assert @answer.valid?
  end

  test "answer should be present" do
    @answer.answer = "     "
    assert_not @answer.valid?
  end
  end
