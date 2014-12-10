class ActivationsController < ApplicationController
  class FailedToActivate < StandardError; end

  respond_to :json

  def create
    if activator.activate
      render json: repo, status: :created
    else
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
