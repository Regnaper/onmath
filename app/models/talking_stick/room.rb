module TalkingStick
  class Room < ApplicationRecord
    has_many :participants, dependent: :destroy
    has_many :signals, dependent: :destroy

    before_validation :sluggify_name
    validates :name, presence: true,
              uniqueness: { case_sensitive: false }

    def self.find_or_create(slug:)
      slug = slug.parameterize
      where(slug: slug).first || create(name: slug.titleize, slug: slug)
    end

    def self.find_not_create(slug:)
      slug = slug.parameterize
      where(slug: slug).first
    end

    def to_param
      slug
    end

    private

    def sluggify_name
      self.slug = name.parameterize unless slug.present?
    end
  end
end
