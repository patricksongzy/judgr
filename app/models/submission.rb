class Submission < ApplicationRecord
  belongs_to :problem
  belongs_to :language
  belongs_to :user
end
