class User < ApplicationRecord
  include Clearance::User

  has_many :problems, dependent: :destroy
end
