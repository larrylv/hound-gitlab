class RepoSerializer < ActiveModel::Serializer
  attributes(
    :active,
    :full_gitlab_name,
    :gitlab_id,
    :id,
    :private
  )
end
