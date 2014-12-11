class MergeRequest
  pattr_initialize :payload

  def comments
    @comments ||= api.merge_request_comments(gitlab_repo_id, merge_request_id)
  end

  def pull_request_files
    @pull_request_files ||= api.
      pull_request_files(full_repo_name, number).
      map { |file| build_commit_file(file) }
  end

  def comment_on_violation(violation)
    api.create_merge_request_comment(
      gitlab_repo_id,
      merge_request_id,
      violation.messages.join("<br>"),
      {
        :line => violation.line_number,
        :path => violation.filename,
        :line_type => 'new'
      }
    )
  end

  def opened?
    state == "opened"
  end

  def head_commit
    @head_commit ||= Commit.new(full_repo_name, payload, api)
  end

  private

  def build_commit_file(file)
    CommitFile.new(file, head_commit)
  end

  def api
    @api ||= Gitlab.client(:endpoint => ENV['GITLAB_ENDPOINT'], :private_token => ENV['HOUND_GITHUB_TOKEN'])
  end

  delegate :gitlab_repo_id, :full_repo_name, :merge_request_id, :state, :to => :payload
end
