json.extract! post, :id, :hora_pub, :titulo, :texto, :publicado, :red_id, :created_at, :updated_at, :approved, :imagen
json.url post_url(post, format: :json)
