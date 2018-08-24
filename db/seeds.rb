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
cliente = Cliente.create(nombre: "Viguard")

logger.info "Redes"
viguard_fb = Red.create(nombre: "FB Viguard", tipo: REDES_TIPOS[:FACEBOOK], cliente: cliente, token: "EAADfZBXaXY3EBAPqkqkmF3gljJqB5HM4iAd5jcFEIpVFAg4m5DTgPpjJJybOOD5oAncbgju5UvwV9rRLUG5gkuMURPgAYYIhNF5lLYZCK97jnDZBtkUZBhwGVgOxuhZBOKXWT4QyzprCN6Vhl7bsc7s0ECZCSA3Ffx4n7HcLWSJ6nAwGXXhJamGdRHBLCuNsj6Cc7k8jF5LAZDZD")
Red.create(nombre: "IG Viguard", tipo: REDES_TIPOS[:INSTAGRAM], cliente: cliente)

logger.info "Post"
post_viguard_fb = FactoryBot.create(:post, hora_pub: Time.zone.now, red: viguard_fb)
# post_viguard_fb.imagen.attach(io: File.open("public/images/buho.jpg"), filename: "buho.jpg", content_type: "image/jpg")
post_viguard_fb.imagen.attach(io: File.open("public/images/owl.png"), filename: "owl.png", content_type: "image/png")
