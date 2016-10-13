class Api::V1::ContractsController < ApiController
  before_filter :find_contract, only: [:show, :edit, :destroy, :update]
  has_scope :by_month, as: :month
  has_scope :by_provider, as: :provider_id
  has_scope :by_child, as: :child_id
  has_scope :by_funder, as: :funder_id
  has_scope :active, :type => :boolean

  # GET /contracts.json
  def index
    if params[:month]
      @contracts = Contract.by_provider(params[:provider_id])
                           .in_month(params[:year], params[:month])
                           .includes(:provider_attendances)
                           .active
                           .where(provider_attendances: {
                             month: params[:month],
                             year: params[:year]
                           })
    else
      @contracts = api_scopes(Contract)
    end

    render json: @contracts
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.status = :active
    if @contract.save
      render json: @contract
    else
      render_error(@contract)
    end
  end

  def update
    if params[:contract][:is_transfer]
      # transfer contract
      start_date = params[:contract][:start_date].to_date
      new_contract = Contract.new(contract_params)
      new_contract.transferred_from = @contract.id
      result = new_contract.save
      if result
        # Remove upcoming months
        @contract.provider_attendances.upcoming(start_date.year, start_date.month + 1).destroy_all
        @contract.update_attributes({end_date: start_date - 1.day, status: :closed})
      else
        @contract = new_contract # To return errors
      end
    else
      result = @contract.update_attributes(contract_params)
    end
    result ? render(json: Contract.where(child_id: @contract.child_id)) : render_error(@contract)
  end

  def destroy
    @contract.destroy ? render_success : render_error
  end

  private

  def find_contract
    @contract = Contract.find(params[:id])
  end

  def contract_params
    params[:contract][:is_full_time] = params[:contract][:is_full_time] == 'true' ? true : false
    params.require(:contract)
          .permit(
            :child_id, :funding_cycle_id, :provider_id, :discount,
            :start_date, :end_date, :is_full_time
          )
  end

end
