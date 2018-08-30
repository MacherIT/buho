# == Schema Information
#
# Table name: redes
#
#  cliente_id     :bigint(8)
#  created_at     :datetime         not null
#  id             :bigint(8)        not null, primary key
#  nombre         :string           default(""), not null
#  nombre_display :string
#  tipo           :integer          default(0), not null
#  token          :string
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_redes_on_cliente_id  (cliente_id)
#
# Foreign Keys
#
#  fk_rails_...  (cliente_id => clientes.id)
#

class RedesController < ApplicationController
  before_action :set_red, only: %i[show edit update destroy]

  # GET /redes
  def index
    @redes = Red.all.order(:cliente_id)
  end

  # GET /redes/1
  def show
  end

  # GET /redes/new
  def new
    @red = Red.new
    @cliente = Cliente.find(params[:cliente_id])
  end

  # GET /redes/1/edit
  def edit
  end

  # POST /redes
  def create
    @red = Red.new(red_params)

    if @red.save
      redirect_to @red, notice: 'Red fue creado satisfactoriamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /redes/1
  def update
    if @red.update(red_params)
      redirect_to @red, notice: 'Red fue guardado satisfactoriamente.'
    else
      render :edit
    end
  end

  # DELETE /redes/1
  def destroy
    @red.destroy
    redirect_to redes_url, notice: 'Red fue eliminado satisfactoriamente.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_red
    @red = Red.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def red_params
    params.require(:red).permit(:tipo, :token, :nombre, :nombre_display, :cliente_id)
  end
end
