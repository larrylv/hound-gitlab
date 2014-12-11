require 'gitlab'

# http://doc.gitlab.com/ee/api/repositories.html#compare-branches-tags-or-commits

class Gitlab::Client
  module Repositories
    def compare(project, from, to)
      get("/projects/#{project}/repository/compare", query: {from: from, to: to})
    end
  end
end
