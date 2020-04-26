module ResultsHelper

  def find_result(test, user)
    user.results.find_by(test_id: test)
  end
end
