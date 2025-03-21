class Profile < ActiveRecord::Base
  belongs_to :user
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  # Validations for other fields
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :job_title, presence: true
  validates :phone_number, presence: true
  validates :contact_email, presence: true
  validates :description, presence: true

  # Custom validation for avatar format
  validate :avatar_format

  private

  # Custom method to validate avatar file type
  def avatar_format
    if avatar.attached? && !avatar.content_type.in?(%w(image/jpeg image/png image/gif))
      errors.add(:avatar, 'must be a JPEG, PNG, or GIF')
    end
  end
end
