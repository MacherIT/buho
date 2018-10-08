class AddIdFacebookPostToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :id_facebook_post, :text
  end
end
