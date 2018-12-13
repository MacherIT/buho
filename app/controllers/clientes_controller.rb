# == Schema Information
#
# Table name: clientes
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  nombre     :string           default(""), not null
#  updated_at :datetime         not null
#

require "net/http"
require "open-uri"
# require "net/http/post/multi+part"

class ClientesController < ApplicationController
  before_action :set_cliente, only: %i[show edit update destroy]

  # GET /clientes
  def index
    @clientes = Cliente.all
    @user = current_user.id

    app_secret = "c7166257539efd50cf8f523de38618cd"
    app_id = "979922088853971"

    # @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, 'https://127.0.0.1:3000')
    # @urlforauth = @oauth.url_for_oauth_code(permissions: "publish_actions")
    # redirect_to(@oauth.url_for_oauth_code)
    # @user = User.find(2).email
    # @test_result = post_test
  end

  # GET /clientes/1
  def show
    # @redes = @cliente.redes
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes
  def create
    @cliente = Cliente.new(cliente_params)
    @cliente.logo.attach(cliente_params['logo'])

    if @cliente.save
      redirect_to @cliente, notice: "Cliente fue creado satisfactoriamente."
    else
      render :new
    end
  end

  # PATCH/PUT /clientes/1
  def update
    if @cliente.update(cliente_params)
      redirect_to @cliente, notice: "Cliente fue guardado satisfactoriamente."
    else
      render :edit
    end
  end

  # DELETE /clientes/1
  def destroy
    @cliente.destroy
    redirect_to clientes_url, notice: "Cliente fue eliminado satisfactoriamente."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cliente
    @cliente = Cliente.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def cliente_params
    params.require(:cliente).permit(:nombre, :logo)
  end
end
