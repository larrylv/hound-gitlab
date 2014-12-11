# http://doc.gitlab.com/ce/api/commits.html#post-comment-to-commit

class Gitlab::Client
  module MergeRequests
    # Adds a comment to a merge request.
    #
    # @example
    #   Gitlab.create_merge_request_comment(5, 1, "Awesome merge!")
    #   Gitlab.create_merge_request_comment('gitlab', 1, "Awesome merge!")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [String] note The content of a comment.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :line The line number
    # @option options [String] :file_path The file path
    # @option options [String] :line_type The line type (new or old)
    # @return [Gitlab::ObjectifiedHash] Information about created merge request comment.
    def create_merge_request_comment(project, id, note, options = {})
      post("/projects/#{project}/merge_request/#{id}/comments", :body => {:note => note}.merge(options))
    end
  end
end

