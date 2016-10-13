class Api::V1::ScalesController < ApiController
  before_filter :find_scale, only: [:show, :edit, :destroy, :update]

  # GET /settings.json
  def index
    @scales = Scale.order(:family_size)
    render json: @scales
  end

  def create
    if @scale.save
      render json: @scale
    else
      render_error(@scale)
    end
  end

  def update
    @scale.update_attributes(scale_params)
    @scale.save ? render(json: @scale) : render_error(@scale)
  end

  private
  def scale_params
    params.require(:scale).permit(:minimum_income, :maximum_income)
  end

  def find_scale
    @scale = Scale.find(params[:id])
  end
end
