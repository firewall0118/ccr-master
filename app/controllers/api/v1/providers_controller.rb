class Api::V1::ProvidersController < ApiController
  before_filter :find_provider, only: [:show, :edit, :destroy, :update, :close_month]

  # GET /settings.json
  def index
    @providers = Provider.order(:family_size)
    render json: @providers
  end

  def create
    if @provider.save
      render json: @provider
    else
      render_error(@provider)
    end
  end

  def close_month
    attendances = @provider.provider_attendances.by_year(params[:year]).by_month(params[:month])
    attendances.each do |attendance|
      attendance.update_attribute(:closed, true)
      Payout.create({
        contract_id: attendance.contract_id,
        funding_cycle_id: attendance.contract.funding_cycle_id,
        provider_attendance_id: attendance.id,
        amount: attendance.contract.daily_rate * attendance.days
      })
    end
    render json: @provider
  end

  def update
    @provider.update_attributes(provider_params)
    @provider.save ? render(json: @provider) : render_error(@provider)
  end

  private

  def find_provider
    @provider = Provider.find(params[:id])
  end
end
