class Commit
  pattr_initialize :gitlab_repo_id, :sha, :api

  def file_content(filename)
    @api.contents(gitlab_repo_id, sha, filename).to_s.force_encoding("UTF-8")
  rescue Gitlab::Error::Error
    ""
  end
end
