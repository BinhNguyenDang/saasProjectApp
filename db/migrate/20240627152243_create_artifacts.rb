class CreateArtifacts < ActiveRecord::Migration[7.1]
  def change
    create_table :artifacts do |t|
      t.string :name
      t.string :key
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
