class User < ApplicationRecord
  include Clearance::User

  has_many :problems, dependent: :destroy

  enum role: [:default, :admin]
  
  after_initialize do
    if self.new_record?
      self.role ||= :default
    end
  end
end
