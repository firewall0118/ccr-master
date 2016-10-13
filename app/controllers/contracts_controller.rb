class ContractsController < ApplicationController
  has_scope :by_provider, as: :provider_id
  has_scope :by_funder, as: :funder_id

  def index
    @contracts = apply_scopes(Contract).order(:id)
    @contracts = @contracts.includes(:child, :provider, :funder)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: format("Contracts - #{Date.today}"),
               template: 'contracts/contracts',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 20,
                 bottom: 25
               }
      end
      format.csv { send_data @contracts.to_csv }
    end
  end

  def show
    @family = Family.find(params[:family_id])
    @child = Child.find(params[:id])
  end

  def new
    flash[:back] = request.referrer
    @child = Child.find(params[:child_id])
    @family = @child.family
    @contract = @child.contracts.new
  end

  def create
    @child = Child.find(params[:contract][:child_id])
    @family = @child.family
    @contract = @child.contracts.new(contract_params)
    if @contract.save
      flash[:success] = 'Child was assigned to Provider successfully.'
      redirect_to flash[:back] || edit_contract_path(@contract)
    else
      flash[:error] = "Couldn't assign the Child to the Provider."
      render action: 'new'
    end
  end

  def edit
    flash[:back] = request.referrer
    @contract = Contract.find(params[:id])
    @child = @contract.child
    @family = @child.family
  end

  def update
    @contract = Contract.find(params[:id])
    @child = @contract.child
    @family = @child.family
    if @contract.update(contract_params)
      flash[:success] = 'Child Provider contract was updated successfully.'
      redirect_to flash[:back] || edit_contract_path(@contract)
    else
      flash[:error] = "Couldn't update the Child Provider contract."
      render action: 'edit'
    end
  end

  private

  def contract_params
    params.require(:contract).permit(
      :start_date, :end_date, :provider_id, :child_id, :funding_cycle_id, :is_full_time, :discount,
      :rejection_note, rejection_reason: []
    )
  end

end
