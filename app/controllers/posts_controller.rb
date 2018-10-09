# == Schema Information
#
# Table name: posts
#
#  approved         :boolean          default(FALSE)
#  created_at       :datetime         not null
#  hora_pub         :datetime         not null
#  id               :bigint(8)        not null, primary key
#  id_facebook_post :text
#  publicado        :integer          default(0), not null
#  red_id           :bigint(8)
#  texto            :string           default(""), not null
#  titulo           :string
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_posts_on_red_id  (red_id)
#
# Foreign Keys
#
#  fk_rails_...  (red_id => redes.id)
#
require "net/http"
require 'json'
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy post_test]

  def post_test
    # return unless @post.approved? && @post.imagen.attached?
    return unless @post.approved?
    @token = @post.red.token
    @page_graph = Koala::Facebook::API.new(@token)

    ###############
    # 100626460032618/feed?message=Hello Fans!&scheduled_publish_time=1538679065&published=false
    ###############
    # @graph.put_wall_post("Hola ", {published:false,scheduled_publish_time:1538680999})
    # Sale de PHP la fecha strtotime("+10 minutes 30 seconds")
    ###############
    begin
      # res = @page_graph.put_picture(rails_blob_url(@post.imagen), caption: @post.texto)
      res = @page_graph.put_wall_post(@post.texto, {published:false,scheduled_publish_time: @post.hora_pub.to_time.to_i})
      # TODO: Salvar este error, por algun motivo no esta andando
    rescue Koala::Facebook::ClientError => e
      res = e.error_user_msg
    end
    #
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
  def by_red
    @posts = Post.of_red(params[:red_id])
    render :index
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
    @redes = Red.all
  end

  # GET /posts/1/edit
  def edit
    @redes = Red.all
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @token = @post.red.token
    @page_graph = Koala::Facebook::API.new(@token)
    if @post.save
      # res = @page_graph.put_picture(File.new("app/assets/images/macher-portada-linkedin.jpg"), {published:false,scheduled_publish_time: @post.hora_pub.to_time.to_i})
      res = @page_graph.put_picture(@post.imagen, {message:@post.texto,published:false,scheduled_publish_time: @post.hora_pub.to_time.to_i})
      # res = @page_graph.put_wall_post(@post.texto, {published:false,scheduled_publish_time: @post.hora_pub.to_time.to_i})
      # @post.id_facebook_post=res.id
      # @post.update
      redirect_to @post, notice: "Post fue creado satisfactoriamente."
    else
      render :new
    end
  end

  # action for post to instagram
  def create_ig
    @post = Post.new(post_params)
    username = @post.red.nombre
    password = @post.red.token #password en instagram
    imagen = @post.imagen
    caption = @post.texto

    if @post.save
      uri = URI('127.0.0.1:8000')
      req = Net::HTTP::Post.new(uri)
      req.set_form_data('username'=>@post.red.nombre,'password'=>password,'imagen'=>imagen,'caption'=>caption)
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        redirect_to @post, notice: "Post fue creado satisfactoriamente."
      else
        res.value
        render:new
      end
    else
      render:new
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
