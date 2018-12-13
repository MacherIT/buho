json.extract! post, :id, :hora_pub, :titulo, :texto, :publicado, :red_id, :created_at, :updated_at, :approved, :imagen, :img, :cliente_logo
json.url post_url(post, format: :json)
