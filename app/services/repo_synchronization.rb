class RepoSynchronization
  ORGANIZATION_TYPE = 'Organization'

  pattr_initialize :user, :gitlab_token
  attr_reader :user

  def api
    @api ||= Gitlab.client(:endpoint => ENV['GITLAB_ENDPOINT'], :private_token => gitlab_token)
  end

  def start
    user.repos.clear

    api.projects.each do |resource|
      attributes = repo_attributes(resource.to_hash)
      user.repos << Repo.find_or_create_with(attributes)
    end
  end

  private

  def repo_attributes(attributes)
    attributes.slice(:private).merge(
      {
        private: !attributes['private'],
        gitlab_id: attributes['id'],
        full_gitlab_name: attributes['name_with_namespace']
      }
    )
  end
end
