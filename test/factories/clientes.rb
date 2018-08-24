# == Schema Information
#
# Table name: clientes
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  nombre     :string           default(""), not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :cliente do
    nombre "MyString"
  end
end
