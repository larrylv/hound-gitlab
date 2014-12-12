# Print violation messages as comments on given GitHub pull request.
class Commenter
  pattr_initialize :merge_request

  def comment_on_violations(violations)
    violations.each do |violation|
      if commenting_policy.allowed_for?(violation)
        merge_request.comment_on_violation(violation)
      end
    end
  end

  private

  def commenting_policy
    @commenting_policy ||= CommentingPolicy.new(merge_request)
  end
end
