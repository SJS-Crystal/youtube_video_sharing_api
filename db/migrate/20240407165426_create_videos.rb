class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
