require 'gitlab_monkey_patch'

class MergeRequest
  pattr_initialize :payload

  def comments
    @comments ||= api.merge_request_comments(gitlab_repo_id, merge_request_id)
  end

  def merge_request_files
    @merge_request_files ||= merge_request_diffs.map { |diff| build_commit_file(diff)}
  end

  def comment_on_violation(violation)
    # comment_on_merge_request(violation)
    comment_on_commit(violation)
  end

  def opened?
    %w(opened reopened).include? state
  end

  def head_commit
    Commit.new(gitlab_repo_id, head_sha, api)
  end

  def head_sha
    @head_sha ||= api.commit(gitlab_repo_id, source_branch).id
  end

  private

  def comment_on_commit(violation)
    api.create_commit_comment(
      gitlab_repo_id,
      head_sha,
      "[RuboCop detection, line :#{violation.line_number}]: &lt;br&gt;#{violation.markdown_display}",
      {
        :line      => violation.line_number,
        :path      => violation.filename,
        :line_type => 'new'
      }
    )
  end

  def comment_on_merge_request(violation)
    api.create_merge_request_comment(
      gitlab_repo_id,
      merge_request_id,
      "[RuboCop detection]: #{violation.messages.join('<br>')}",
      {
        :line      => violation.patch_position,
        :file_path => violation.filename,
        :line_type => 'new'
      }
    )
  end

  def build_commit_file(file)
    CommitFile.new(file, head_commit)
  end

  def api
    @api ||= Gitlab.client(:endpoint => ENV['GITLAB_ENDPOINT'], :private_token => ENV['HOUND_GITLAB_TOKEN'])
  end

  def merge_request_diffs
    @merge_request_diffs ||= api.compare(gitlab_repo_id, target_branch, source_branch).
      diffs.reject{ |d| d["deleted_file"] }.
      map { |d| Hashie::Mash.new(:filename => d["new_path"], :patch => d["diff"]) }
  end

  delegate :gitlab_repo_id, :full_repo_name, :merge_request_id, :state, :source_branch, :target_branch, :to => :payload
end
