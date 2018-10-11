class AddPassUserToRed < ActiveRecord::Migration[5.2]
  def change
    add_column :redes, :user, :string
    add_column :redes, :pass, :string
  end
end
