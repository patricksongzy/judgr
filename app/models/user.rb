class User < ApplicationRecord
  include Clearance::User

  has_many :problems, dependent: :destroy

  validates :full_name, presence: true
  validates :password_confirmation, presence: true
  validates :password, confirmation: { case_sensitive: true }

  enum role: [:default, :admin]
  
  after_initialize do
    self.role ||= :default if self.new_record?
  end
end
