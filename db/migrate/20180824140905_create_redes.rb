class CreateRedes < ActiveRecord::Migration[5.2]
  def change
    create_table :redes do |t|
      t.integer :tipo, null: false, default: 0
      t.string :token
      t.string :nombre, null: false, default: ""
      t.string :nombre_display
      t.references :cliente, foreign_key: true

      t.timestamps
    end
  end
end
