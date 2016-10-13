class FundingCyclesController < ApplicationController

  def new
    @funder = (id = params[:funder_id]) ? Funder.find(id) : @funding_cycle.funder
    @funding_cycle = @funder.funding_cycles.new
  end

  def create
    @funder = (id = params[:funder_id]) ? Funder.find(id) : @funding_cycle.funder
    @funding_cycle = @funder.funding_cycles.new(funding_cycle_params)

    if @funding_cycle.save
      flash[:success] = 'Funding cycle was added to Funder successfully.'
      redirect_to funder_path(@funder)
    else
      flash[:error] = "Couldn't add the Funding cycle to the Funder."
      render action: 'new'
    end
  end

  def edit
    @funding_cycle = FundingCycle.find(params[:id])
    @funder = @funding_cycle.funder
  end

  def show
    @funding_cycle = FundingCycle.find(params[:id])
    @funder = @funding_cycle.funder
  end

  def update
    @funding_cycle = FundingCycle.find(params[:id])
    @funder = @funding_cycle.funder
    if @funding_cycle.update(funding_cycle_params)
      flash[:success] = 'Funding Cycle was updated successfully.'
      redirect_to funder_path(@funder)
    else
      flash[:error] = "Couldn't update the FundingCycle."
      render action: 'edit'
    end
  end

  def destroy
    @cycle = FundingCycle.find(params[:id])
    @cycle.destroy
    redirect_to :back
  end

private

  def funding_cycle_params
    params.require(:funding_cycle).permit(:amount,:start_date,:end_date,:notes)
  end

end
