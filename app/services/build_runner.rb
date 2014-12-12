class BuildRunner
  pattr_initialize :payload

  def run
    if repo && opened_merge_request?
      repo.builds.create!(
        violations: violations,
        merge_request_id: payload.merge_request_id,
        commit_sha: merge_request.head_sha
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
      find_and_update(payload.gitlab_repo_id, payload.full_repo_name)
  end
end
