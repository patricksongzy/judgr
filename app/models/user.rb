class User < ApplicationRecord
  include Clearance::User

  has_many :submissions, dependent: :destroy

  validates :full_name, presence: true
  validates :password_confirmation, presence: true, on: :create
  validates :password, confirmation: { case_sensitive: true }, on: :create

  enum role: [:default, :admin]
  
  after_initialize do
    self.role ||= :default if self.new_record?
  end

  def confirm_email
    self.email_confirmed_at = Time.current.to_i
    save!
  end

  def confirmed?
    self.email_confirmed_at.present?
  end
end
