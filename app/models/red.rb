# == Schema Information
#
# Table name: reds
#
#  cliente_id     :bigint(8)
#  created_at     :datetime         not null
#  id             :bigint(8)        not null, primary key
#  nombre         :string           default(""), not null
#  nombre_display :string
#  tipo           :integer          default(0), not null
#  token          :string
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_reds_on_cliente_id  (cliente_id)
#
# Foreign Keys
#
#  fk_rails_...  (cliente_id => clientes.id)
#

class Red < ApplicationRecord
  belongs_to :cliente

  def tipo_cast
    REDES_TIPOS.select { |_k, v| v == tipo }.keys.first.to_s.capitalize
  end
end
