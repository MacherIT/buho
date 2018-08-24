class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.datetime :hora_pub, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.string :titulo
      t.string :texto, null: false, default: ""
      t.integer :publicado, null: false, default: 0
      t.references :red, foreign_key: true

      t.timestamps
    end
  end
end
