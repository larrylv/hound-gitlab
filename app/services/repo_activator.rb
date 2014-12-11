class RepoActivator
  def initialize(gitlab_token:, repo:)
    @gitlab_token = gitlab_token
    @repo = repo
  end

  def activate
    activate_repo
  end

  def deactivate
    change_repository_state_quietly do
      delete_webhook && repo.deactivate
    end
  end

  private

  attr_reader :gitlab_token, :repo

  def activate_repo
    change_repository_state_quietly do
      add_hound_to_repo && create_webhook && repo.activate
    end
  end

  def change_repository_state_quietly
    yield
  rescue Gitlab::Error::Error => error
    Rails.logger.error(error)
    false
  end

  def add_hound_to_repo
    gitlab_userid = ENV.fetch("HOUND_GITLAB_USERID")
    gitlab.add_team_member(repo.gitlab_id, gitlab_userid, 30) # 30 means DEVELOPER
  end

  def gitlab
    @gitlab ||= Gitlab.client(:endpoint => ENV['GITLAB_ENDPOINT'], :private_token => gitlab_token)
  end

  HOOK_OPTIONS = {
    :merge_requests_events => 'true',
    :push_events           => 'false',
    :issues_events         => 'false'
  }
  def create_webhook
    hook = gitlab.add_project_hook(repo.gitlab_id, builds_url, HOOK_OPTIONS)
    hook = hook.to_hash if hook
    repo.update(hook_id: hook["id"]) if hook && hook["id"]
  end

  def delete_webhook
    gitlab.delete_project_hook(repo.gitlab_id, repo.hook_id) do
      repo.update(hook_id: nil)
    end
  end

  def builds_url
    URI.join("#{protocol}://#{ENV["HOST"]}", "builds").to_s
  end

  def protocol
    if ENV.fetch("ENABLE_HTTPS") == "yes"
      "https"
    else
      "http"
    end
  end
end
