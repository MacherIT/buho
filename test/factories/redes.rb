# == Schema Information
#
# Table name: redes
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
#  index_redes_on_cliente_id  (cliente_id)
#
# Foreign Keys
#
#  fk_rails_...  (cliente_id => clientes.id)
#

FactoryBot.define do
  factory :red do
    tipo 1
    token
    nombre "MyString"
    nombre_display
    cliente { Cliente.all.sample }
  end
end
