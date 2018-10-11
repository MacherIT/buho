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

class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token, except: [:update, :destroy]

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

  def index_json
    render json: Post.all.as_json(methods: :img_on_disk)
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
      res = @page_graph.put_picture(
        File.new(@post.img_on_disk),
        FileMagic.new(FileMagic::MAGIC_MIME).file(@post.img_on_disk),
        {
          message:@post.texto,
          published:false,
          scheduled_publish_time: @post.hora_pub.to_time.to_i
        }
      )
      if(res)
        @post.id_facebook_post = res['id']
        if @post.save
          render json: {message: "Post fue creado satisfactoriamente."}, status: 201
        else
          render json: {message: "Error"}, status: 500
        end
      end
    else
      render :new
    end
  end

  def create_ig
    @post = Post.new(post_params)
    if @post.save
      require 'net/http'

      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base.slice(0, 32))

      url = URI.parse(URL_PYBUHO)
      req = Net::HTTP::Post.new(url.to_s)
      req.body = URI.encode_www_form({
        username: @post.red.user,
        password: crypt.decrypt_and_verify(@post.red.pass),
        imagen: "#{URL_SERVIDOR}#{@post.img}",
        caption: @post.texto,
        })

      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      
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
