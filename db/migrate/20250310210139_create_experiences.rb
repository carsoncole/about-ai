class CreateExperiences < ActiveRecord::Migration[8.0]
  def change
    create_table :experiences do |t|
      t.string :title
      t.string :organization
      t.date :start_date
      t.date :end_date
      t.string :description
      t.string :location
      t.string :ai_context

      t.timestamps
    end
  end
end
