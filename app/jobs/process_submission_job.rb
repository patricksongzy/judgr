class ProcessSubmissionJob < ApplicationJob
  queue_as :default

  def perform(submission)
    submission.process
    submission.save!
  end
end
