# == Schema Information
#
# Table name: posts
#
#  approved   :boolean          default(FALSE)
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
  before_action :set_post, only: %i[show edit update destroy post_test by_cliente_by_red test]

  def post_test
    return unless @post.approved? && @post.imagen.attached?
    @token = @post.red.token
    @page_graph = Koala::Facebook::API.new(@token)

    begin
      res = @page_graph.put_picture(@post.imagen, caption: @post.texto)
      # TODO: Salvar este error, por algun motivo no esta andando
    rescue Koala::Facebook::ClientError => e
      res = e.error_user_msg
    end
    # res = @page_graph.put_picture("https://www.facebook.com/images/fb_icon_325x325.png", caption: @post.texto)
    # res = @page_graph.put_picture(rails_blob_url(@post.imagen), caption: @post.texto)
    respond_to do |format|
      format.html { redirect_to @post, notice: res.to_s }
      format.json { render json: res }
    end
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

  # GET /clientes/:cliente_id/redes/:red_id/posts
  def by_cliente_by_red
    @posts = Post.all
    # @clienteid = params[:cliente_id]
    # @redid= params[:red_id]
  end

  # GET /posts
  def index
    @posts = Post.of_red(params[:red_id])
    # @clienteid = params[:cliente_id]
    # @redid= params[:red_id]
  end

  def test
    render 'hola'
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @redes = Red.all
  end

  # GET /posts/1/edit
  def edit
    @redes = Red.all
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
    params.require(:post).permit(:hora_pub, :titulo, :texto, :publicado, :red_id, :approved, :imagen)
  end
end
