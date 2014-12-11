class BuildsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate, only: [:create]

  def create
    JobQueue.push(build_job_class, payload.data)
    head :ok
  end

  private

  def force_https?
    false
  end

  def build_job_class
    if payload.changed_files < ENV['CHANGED_FILES_THRESHOLD'].to_i
      SmallBuildJob
    else
      LargeBuildJob
    end
  end

  def payload
    @payload ||= Payload.new(params)
  end
end
