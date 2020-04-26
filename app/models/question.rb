class Question < ActiveRecord::Base
  belongs_to :test
  has_many :answers, dependent: :destroy
  validates :question, presence: true, length: { maximum: 100 }
  validates_numericality_of :right_answer, only_integer: true
end
