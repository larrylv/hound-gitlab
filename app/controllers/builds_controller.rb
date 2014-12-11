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
    LargeBuildJob
  end

  def payload
    @payload ||= Payload.new(params)
  end
end
