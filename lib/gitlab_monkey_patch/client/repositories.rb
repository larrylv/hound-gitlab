# http://doc.gitlab.com/ee/api/repositories.html#compare-branches-tags-or-commits

class Gitlab::Client
  module Repositories
    def compare(project, from, to)
      get("/projects/#{project}/repository/compare", query: {from: from, to: to})
    end

    def contents(project, sha, file_path)
      raw_get("/projects/#{project}/repository/blobs/#{sha}?filepath=#{file_path}")
    end
  end
end
