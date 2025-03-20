class Profile < ActiveRecord::Base
    belongs_to :user
    has_one_attached :avatar do |attachable|
      attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
    end
  
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :job_title, presence: true
    validates :phone_number, presence: true
    validates :contact_email, presence: true
    validates :description, presence: true
end