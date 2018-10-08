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

FactoryBot.define do
  factory :post do
    hora_pub "2018-08-24 14:35:23"
    texto "Algun texto de prueba"
    titulo "Un buen titulo"
    publicado PUBLICADO_ESTADOS[:PUBLICADO]
    red
  end
end
