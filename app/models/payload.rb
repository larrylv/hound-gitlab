require 'json'

# https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/web_hooks/web_hooks.md#merge-request-events

class Payload
  pattr_initialize :unparsed_data

  def data
    @data ||= parse_data
  end

  def gitlab_repo_id
    merge_request["target_project_id"]
  end

  def full_repo_name
    "#{repository['namespace']} / #{repository['name']}"
  end

  def merge_request_id
    merge_request["id"]
  end

  def state
    merge_request["state"]
  end

  def source_branch
    merge_request["last_commit"]["id"]
  end

  def target_branch
    merge_request["target_branch"]
  end

  private

  def parse_data
    if unparsed_data.is_a? String
      JSON.parse(unparsed_data)
    else
      unparsed_data
    end
  end

  def merge_request
    @merge_request ||= data.fetch("object_attributes", {})
  end

  def repository
    @repository ||= merge_request["target"]
  end
end
