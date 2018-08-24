# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

logger = Logger.new(STDOUT)

logger.info "Usuario"
User.create(email: "hola@macherit.com", password: "123456")

logger.info "Clientes"
cliente = FactoryBot.create(:cliente, nombre: "Mil Ruedas")

logger.info "Redes"
FactoryBot.create(:red, nombre: "FB Mil Ruedas", tipo: FACEBOOK, cliente: cliente)
FactoryBot.create(:red, nombre: "IG Mil Ruedas", tipo: INSTAGRAM, cliente: cliente)
