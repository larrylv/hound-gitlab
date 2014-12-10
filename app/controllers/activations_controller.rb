class ActivationsController < ApplicationController
  class FailedToActivate < StandardError; end

  respond_to :json

  def create
    if activator.activate
      render json: repo, status: :created
    else
      report_exception(
        FailedToActivate.new('Failed to activate repo'),
        user_id: current_user.id,
        repo_id: params[:repo_id]
      )

      head 502
    end
  end

  private

  def activator
    RepoActivator.new(repo: repo, github_token: github_token)
  end

  def repo
    @repo ||= current_user.repos.find(params[:repo_id])
  end

  def github_token
    session.fetch(:github_token)
  end
end
