class RepoSerializer < ActiveModel::Serializer
  attributes(
    :active,
    :full_github_name,
    :github_id,
    :id,
    :in_organization,
    :private,
  )
end
