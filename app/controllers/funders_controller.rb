class FundersController < ApplicationController
  before_filter :find_funder, only: [:show, :edit, :update, :destroy]
  

  def index
    @funders = Funder.includes(:funding_cycles)
  end

  def show
  end

  def new
    @funder = Funder.new
    @funder.funding_cycles.build
  end

  def create
    @funder= Funder.new(funder_params)
    if @funder.save
      flash[:success] = 'Funder was created successfully.'
      redirect_to funders_path
    else
      flash[:error] = "Couldn't create the funder."
      render action: 'new'
    end
  end

  def edit
    @funder.funding_cycles.build unless @funder.funding_cycles.present?
  end

  def update
    if @funder.update(funder_params)
      flash[:success] = 'Funder was updated successfully.'
      redirect_to funder_path(@funder)
    else
      flash[:error] = "Couldn't update the funder."
      render action: 'edit'
    end
  end

  def destroy
    @funder.destroy
    redirect_to funders_path
  end

  private

  def find_funder
    @funder = Funder.find(params[:id])
  end

  def funder_params
    params.require(:funder).permit(
      :name, :abbreviation, :address, :phone_number, :contact_person,
      :max_family_size, :email,:notes, :county_ids => [],
      funding_cycles_attributes: [:id, :amount,:start_date,:end_date,:notes, :_destroy]
    )
  end

end
