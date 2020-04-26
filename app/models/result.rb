class Result < ActiveRecord::Base
  serialize :results, Array
  belongs_to :user
  belongs_to :test
  default_scope { order('results.created_at DESC') }
  validates :user_id, presence: true
  validates :test_id, presence: true
  validates_numericality_of :attempt_count, :pass_time
  validates_uniqueness_of :test_id, scope: :user_id, message: "уже был пройден Вами ранее!"
end
