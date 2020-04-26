class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, length: { maximum: 140 }
  validate  :picture_size
  validate  :blank_message?

  private

  # Проводит валидацию размера загруженного изображения.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "вложение должно быть меньше 5MB")
    end
  end

  def blank_message?
    if picture.size == 0 && content.blank?
      errors.add(:content, "не может быть пустым")
    end
  end
end