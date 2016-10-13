class ProviderRatesController < ApplicationController
  before_filter :find_provider

  def index
    @provider_rates = @provider.provider_rates
  end

  def new
    @provider_rate = @provider.provider_rates.new
  end

  def create
    @provider_rate = @provider.provider_rates.new(provider_rate_params)

    if @provider_rate.save
      flash[:success] = 'Provider rate was added to provider successfully.'
      redirect_to provider_path(@provider)
    else
      flash[:error] = "Couldn't add the Provider rate to the Provider."
      render action: 'new'
    end
  end

  def edit
    @provider_rate = ProviderRate.find(params[:id])
  end

  def show
    @provider_rate = ProviderRate.find(params[:id])
  end

  def update
    @provider_rate = ProviderRate.find(params[:id])
    if @provider_rate.update(provider_rate_params)
      flash[:success] = 'Funding Cycle was updated successfully.'
      redirect_to provider_path(@provider)
    else
      flash[:error] = "Couldn't update the ProviderRate."
      render action: 'edit'
    end
  end

  private

  def find_provider
    @provider = Provider.find(params[:provider_id])
  end

  def provider_rate_params
    params.require(:provider_rate).permit(:amount,:start_date,:end_date,:notes)
  end
end