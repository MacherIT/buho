class RedsController < ApplicationController
  before_action :set_red, only: [:show, :edit, :update, :destroy]

  # GET /reds
  def index
    @reds = Red.all
  end

  # GET /reds/1
  def show
  end

  # GET /reds/new
  def new
    @red = Red.new
  end

  # GET /reds/1/edit
  def edit
  end

  # POST /reds
  def create
    @red = Red.new(red_params)

    if @red.save
      redirect_to @red, notice: 'Red fue creado satisfactoriamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /reds/1
  def update
    if @red.update(red_params)
      redirect_to @red, notice: 'Red fue guardado satisfactoriamente.'
    else
      render :edit
    end
  end

  # DELETE /reds/1
  def destroy
    @red.destroy
    redirect_to reds_url, notice: 'Red fue eliminado satisfactoriamente.'
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
