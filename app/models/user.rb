class User < ApplicationRecord
  include Clearance::User

  has_many :problems, dependent: :destroy

  enum role: [:default, :admin]
  
  after_initialize do
    self.role ||= :default if self.new_record?
  end
end
