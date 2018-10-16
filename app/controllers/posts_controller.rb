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
  # skip_before_action :verify_authenticity_token, except: %i[destroy]
  skip_before_action :verify_authenticity_token

  before_action :set_post, only: %i[show edit update update_ig destroy destroy_ig post_test]

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
      res = @page_graph.put_wall_post(@post.texto, published: false, scheduled_publish_time: @post.hora_pub.to_time.to_i)
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
        message: @post.texto,
        published: false,
        scheduled_publish_time: @post.hora_pub.to_time.to_i
      )
      if res
        @post.id_facebook_post = res["id"]
        if @post.save
          render json: { message: "Post fue creado satisfactoriamente." }, status: :created
        else
          render json: { message: "Error" }, status: :internal_server_error
        end
      end
    else
      render :new
    end
  end

  def create_ig
    @post = Post.new(post_params)
    if @post.save
      render json: {}, status: :created
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      if @post.id_facebook_post
        @page_graph = Koala::Facebook::API.new(@post.red.token)
        del = @page_graph.delete_object(@post.id_facebook_post)
        if del && del["success"]
          @post.publicado = 0
          res = @page_graph.put_picture(
            File.new(@post.img_on_disk),
            FileMagic.new(FileMagic::MAGIC_MIME).file(@post.img_on_disk),
            message: @post.texto,
            published: false,
            scheduled_publish_time: @post.hora_pub.to_time.to_i
          )
          if res
            @post.id_facebook_post = res["id"]
            if @post.save
              render json: { message: "Post fue actualizado correctamente." }
            else
              render json: { message: "Error" }, status: :internal_server_error
            end
          end
        else
          render json: { message: "Error" }, status: :internal_server_error
        end
      else
        render json: { message: "Post fue actualizado correctamente." }
      end
    else
      render :edit
    end
  end

  def update_ig
    if @post.update(post_params)
      render json: { message: "Post fue actualizado correctamente." }
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    if @post.id_facebook_post
      @page_graph = Koala::Facebook::API.new(@post.red.token)
      del = @page_graph.delete_object(@post.id_facebook_post)
      if del && del["success"]
        @post.destroy
        render json: { message: "Post fue eliminado satisfactoriamente." }
      else
        render json: { message: "Error" }, status: :internal_server_error
      end
    end
  end

  def destroy_ig
    @post.destroy
    render json: { message: "Post fue eliminado satisfactoriamente." }
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
