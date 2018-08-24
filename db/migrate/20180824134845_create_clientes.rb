class CreateClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :clientes do |t|
      t.string :nombre, null: false, default: ""

      t.timestamps
    end
  end
end
