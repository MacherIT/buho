# == Schema Information
#
# Table name: clientes
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  nombre     :string           default(""), not null
#  updated_at :datetime         not null
#

class Cliente < ApplicationRecord
  has_many :redes, dependent: :destroy
  has_many :posts, through: :redes

  validates :nombre, presence: true
end
