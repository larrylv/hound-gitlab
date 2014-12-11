class BuildRunner
  pattr_initialize :payload

  def run
    if repo && opened_merge_request?
      repo.builds.create!(
        violations: violations,
        pull_request_number: payload.pull_request_number,
        commit_sha: payload.head_sha,
      )
      commenter.comment_on_violations(violations)
    end
  end

  private

  def opened_merge_request?
    merge_request.opened?
  end

  def violations
    @violations ||= style_checker.violations
  end

  def style_checker
    StyleChecker.new(merge_request)
  end

  def commenter
    Commenter.new(merge_request)
  end

  def merge_request
    @merge_request ||= MergeRequest.new(payload)
  end

  def repo
    @repo ||= Repo.active.
      find_and_update(payload.github_repo_id, payload.full_repo_name)
  end
end
