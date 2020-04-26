class Test < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :results, dependent: :destroy
  validates :name, :theme, :subtheme, presence: true, length: { maximum: 100 }
  validates_uniqueness_of :name
end