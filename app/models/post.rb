# == Schema Information
#
# Table name: posts
#
#  approved         :boolean          default(FALSE)
#  created_at       :datetime         not null
#  hora_pub         :datetime         not null
#  id               :bigint(8)        not null, primary key
#  id_facebook_post :text
#  publicado        :integer          default(0), not null
#  red_id           :bigint(8)
#  texto            :string           default(""), not null
#  titulo           :string
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_posts_on_red_id  (red_id)
#
# Foreign Keys
#
#  fk_rails_...  (red_id => redes.id)
#

class Post < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :red
  has_one_attached :imagen

  scope :of_red, -> (rid) {
    where(red_id: rid)
  }

  def img_on_disk
    ActiveStorage::Blob.service.send(:path_for, imagen.key)
  end

  def img
    rails_blob_path(imagen, only_path: true)
  end

  scope :no_publicados_viejos_ig, -> () {
    includes(:red).where("publicado = 0 AND hora_pub <= (?) AND redes.tipo = (?)", Time.now, REDES_TIPOS[:INSTAGRAM]).references(:red)
  }

  def self.postear_programados
    Post.no_publicados_viejos_ig.each do |post|
      require 'net/http'

      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base.slice(0, 32))

      url = URI.parse(URL_PYBUHO)
      req = Net::HTTP::Post.new(url.to_s)
      req.body = URI.encode_www_form({
        username: post.red.user,
        password: crypt.decrypt_and_verify(post.red.pass),
        imagen: "#{URL_SERVIDOR}#{post.img}",
        caption: post.texto,
        })

      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      # por ahora este bloque de codigo va aca arriba hasta que modifique el endpoint de python
      post.publicado=1
      post.save
    end

  end
end
