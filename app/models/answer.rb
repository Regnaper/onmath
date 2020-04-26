class Answer < ActiveRecord::Base
  belongs_to :question
  validates :answer, presence: true, length: { maximum: 100 }
end
