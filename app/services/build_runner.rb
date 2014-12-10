class BuildRunner
  pattr_initialize :payload

  def run
    if repo && relevant_pull_request?
      repo.builds.create!(
        violations: violations,
        pull_request_number: payload.pull_request_number,
        commit_sha: payload.head_sha,
      )
      commenter.comment_on_violations(violations)
    end
  end

  private

  def relevant_pull_request?
    pull_request.opened? || pull_request.synchronize?
  end

  def violations
    @violations ||= style_checker.violations
  end

  def style_checker
    StyleChecker.new(pull_request)
  end

  def commenter
    Commenter.new(pull_request)
  end

  def pull_request
    @pull_request ||= PullRequest.new(payload)
  end

  def repo
    @repo ||= Repo.active.
      find_and_update(payload.github_repo_id, payload.full_repo_name)
  end
end
