class Skill < ApplicationRecord
  enum :category, [:Languages, :Frameworks, :Databases, :devops_cloud, :Other]
end
