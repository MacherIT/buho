# == Schema Information
#
# Table name: posts
#
#  created_at :datetime         not null
#  hora_pub   :datetime         not null
#  id         :bigint(8)        not null, primary key
#  publicado  :integer          default(0), not null
#  red_id     :bigint(8)
#  texto      :string           default(""), not null
#  titulo     :string
#  updated_at :datetime         not null
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
  belongs_to :red
  has_one_attached :imagen
end
