module TestsHelper

  def user_test_result(test, user_results)
    user_results.find_by(test_id: test)
  end
end
