class UserSerializer < ActiveModel::Serializer
  attributes :id, :gitlab_username, :refreshing_repos
end
