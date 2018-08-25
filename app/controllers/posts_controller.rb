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

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy post_test]

  def post_test
    return unless @post.imagen.attached?
    # @post = Cliente.find(params[:cliente_id]).posts.last
    # page_id = 840441896130892 # (Viguard)
    # page_id = @cliente.page_id
    @token = @post.red.token

    @page_graph = Koala::Facebook::API.new(@token)
    # me = @page_graph.get_object('me') # I'm a page
    # @page_graph.put_picture(File.open('public/images/buho.jpg'), {caption: "Comentario"})

    # open('temp.png', 'wb') do |file|
    #   file << open(Rails.application.routes.url_helpers.rails_blob_url(@post.imagen, host: 'localhost:5000')).read
    # end
    # @page_graph.put_picture(File.open('temp.png'), {caption: "Comentario"})

    # @page_graph.put_picture(open(Rails.application.routes.url_helpers.rails_blob_url(@post.imagen, host: 'localhost:5000') ), {caption: "Comentario"})

    # FIXME: No se esta casteando bien la imagen
    @page_graph.put_picture(rails_blob_url(@post.imagen), caption: @post.texto)
    # @page_graph.put_picture('https://www.facebook.com/images/fb_icon_325x325.png', caption: "Comentario")

    # Ejemplo para cuando la foto ya esta subida
    # uri = URI("https://graph.facebook.com/#{page_id}/photos")
    # res = Net::HTTP.post_form(
    #   uri,
    #   "data" => @post.imagen.attachment.blob,
    #   # "url" => "https://www.facebook.com/images/fb_icon_325x325.png",
    #   "caption" => "Comentario de la foto",
    #   "access_token" => token
    # )
    # puts res.body
    # res.body
  end

  # GET post_imagen/:id
  def imagen_url
    @imagen_url = nil
    @imagen = Post.find(params[:id]).imagen
    @imagen_url = rails_blob_url(@imagen) if @imagen.attached?
    respond_to do |format|
      format.json { render json: @imagen_url }
    end
  end

  # GET /posts
  def index
    @posts = Post.all
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post fue creado satisfactoriamente."
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post fue guardado satisfactoriamente."
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post fue eliminado satisfactoriamente."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:hora_pub, :titulo, :texto, :publicado, :red_id)
  end
end
