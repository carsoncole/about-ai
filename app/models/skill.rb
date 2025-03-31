class Skill < ApplicationRecord
  enum :category, [:Languages, :Frameworks, :Databases, :"Devops/Cloud", :Other]
end
