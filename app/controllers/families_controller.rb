class FamiliesController < ApplicationController
  before_action :find_family, except: [:index, :new, :create]

  def index
    if params[:status].present?
      @families = Family.with_status(params[:status])
    else
      @families = Family.all
    end
  end

  def show
    @children = @family.children
    @note     = FamilyNote.new
  end

  def new
    @family = Family.new
    @family.redetermination_due_date = Time.now + 6.months
  end

  def create
    @family = Family.new(family_params)
    @family.save
    @family.first_parent = params[:family][:first_parent]
    @family.second_parent = params[:family][:second_parent]

    if @family.errors.empty?
      flash[:success] = 'Family was created successfully.'
      redirect_to @family
    else
      flash[:error] = "Couldn't create the family."
      render action: 'new'
    end
  end

  def edit
    @first_parent = @family.first_parent
    @second_parent = @family.second_parent
  end

  def update
    @family.update(family_params)
    @family.first_parent = params[:family][:first_parent]
    @family.second_parent = params[:family][:second_parent]

    if @family.errors.empty?
      flash[:success] = 'Family was updated successfully.'
      redirect_to family_path(@family)
    else
      # To fix refreshed parent fields, set two instance variables
      @first_parent = Parent.new(params[:family][:first_parent].permit!)
      @second_parent = Parent.new(params[:family][:second_parent].permit!)
      flash[:error] = "Couldn't update the family."
      render action: 'edit'
    end
  end

  def destroy
    @family.destroy
    redirect_to families_path, success: "Family deleted successfully"
  end

  def redeterminate
    @children = @family.children
  end

  def update_redetermination
    @contracts = @family.contracts

    # Reject application after redetermination
    if params[:family][:status] == "denied"
      @contracts.update_all({status: :inactive})

      @family.status = :denied
      @family.redeterminated_at = Time.now
      @family.redetermination_due_date = nil
      @family.save!
    else
      @family.status = :redeterminated
      @family.redeterminated_at = Time.now
      @family.redetermination_due_date = 6.months.from_now

      # track active_income_at to keep the income history
      @family.redetermination_active_at = params[:family][:redetermination_active_at]
      @family.save!

      # track income
      @family.first_parent = params[:family][:first_parent]
      @family.second_parent = params[:family][:second_parent]

      @family.contracts.upcoming.each do |contract|
        contract.calculate_fees
        contract.save
      end
    end

    redirect_to @family, success: "Re-determination has been done."
  end

  def award_letter
    @contract = Contract.find(params[:contract_id])

    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: format("%s's award letter_#{@contract.id}", @family.first_parent.full_name),
               template: 'families/award_letter',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 8,
                 bottom: 25
               }
      end
    end
  end

  def provider_letter
    @contract = Contract.find(params[:contract_id])

    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: format("%s's provider letter_#{@contract.id}", @family.first_parent.full_name),
               template: 'families/provider_letter',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 8,
                 bottom: 25
               }
      end
    end
  end

  def termination_notice
    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: format("%s's termination_notice#{Time.now.to_date}", @family.first_parent.full_name),
               template: 'families/termination_notice',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 8,
                 bottom: 25
               }
      end
    end
  end

  def information_request
    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: format("%s's information_request#{Time.now.to_date}", @family.first_parent.full_name),
               template: 'families/information_request',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 8,
                 bottom: 25
               }
      end
    end
  end

  def redetermination_notice
    if @family.redetermination_due_date.nil?
      flash[:error] = "Re-determination due date is empty"
      redirect_to :back and return
    end

    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: format("%s's redetermination_notice#{Time.now.to_date}", @family.first_parent.full_name),
               template: 'families/redetermination_notice',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 8,
                 bottom: 25
               }
      end
    end
  end

  def redetermination_denial_letter
    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf: format("%s's redetermination_denial_letter_#{Time.now.to_date}", @family.first_parent.full_name),
               template: 'families/redetermination_denial_letter',
               layout: 'layouts/pdf.html.slim',
               page_size: 'Letter',
               header: {
                 spacing: 2
               },
               footer: {
                 spacing: 10
               },
               margin: {
                 top: 8,
                 bottom: 25
               }
      end
    end
  end

  private

  def find_family
    @family = Family.find(params[:id])
  end

  def family_params
    whitelist = params.require(:family).permit(
      :case_id,
      :first_parent,
      :second_parent,
      :redetermination_due_date,
      :redetermiated_at,
      :last_active_income_at
    )
  end
end
