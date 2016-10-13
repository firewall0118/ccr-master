class ProvidersController < ApplicationController
  before_filter :admin_only
  before_filter :find_provider, only: [:show, :edit, :update, :destroy]

  def index
    @providers = Provider.all.includes(:provider_type)
  end

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params)
    if @provider.save
      flash[:success] = 'Provider was created successfully.'
      redirect_to providers_path
    else
      flash[:error] = "Couldn't create the provider."
      render action: 'new'
    end
  end

  def update
    if @provider.update(provider_params)
      flash[:success] = 'Provider was updated successfully.'
      redirect_to providers_path
    else
      flash[:error] = "Couldn't update the provider."
      render action: 'edit'
    end
  end

  def destroy
    @provider.destroy
    redirect_to providers_path, success: "Provider was deleted."
  end

  # This is a form to save a summary of attendances for several contracts
  # filtered by month and provider
  def attendances
    # nothing here, everything is asked to JSON API
    # this action should render initial template only.
  end

  private

  def find_provider
    @provider = Provider.find(params[:id])
  end

  def provider_params
    params.require(:provider)
          .permit( :name,
                   :provider_type_id,
                   :director_name,
                   :assistant_director_name,
                   :county_id,
                   :email,
                   :vendor_number,
                   :phone_number,
                   :alternate_phone_number,
                   :fax_number,
                   :website,
                   :physical_address_street,
                   :physical_address_city,
                   :physical_address_state,
                   :physical_address_zip,
                   :mailing_address_street,
                   :mailing_address_city,
                   :mailing_address_state,
                   :mailing_address_zip,
                   :provider_license_type,
                   :license_number,
                   :license_issue_date,
                   :license_exempt_expiration_date,
                   :license_expiration_date,
                   :has_sibling_discounts,
                   :sibling_discount_flat_amount,
                   :sibling_discount_percentage,
                   :additional_discount_notes,
                   :sibling_discount_part_time_flat_amount,
                   :sibling_discount_part_time_percentage,
                   :provider_rates_attributes => [
                      :part_time_toddler_weekly_rate,
                      :full_time_toddler_weekly_rate,
                      :part_time_infant_weekly_rate,
                      :full_time_infant_weekly_rate,
                      :part_time_school_weekly_rate,
                      :full_time_school_weekly_rate,
                      :part_time_preschool_weekly_rate,
                      :full_time_preschool_weekly_rate,
                      :has_sibling_discounts,
                      :full_time_sibling_discount_flat_amount_cents,
                      :full_time_sibling_discount_percentage,
                      :part_time_sibling_discount_flat_amount_cents,
                      :part_time_sibling_discount_percentage,
                      :additional_discount_notes,
                      :part_time_toddler_weekly_rate_cents,
                      :part_time_infant_weekly_rate_cents ,
                      :part_time_school_weekly_rate_cents ,
                      :part_time_preschool_weekly_rate_cents,
                      :full_time_toddler_weekly_rate_cents,
                      :full_time_infant_weekly_rate_cents ,
                      :full_time_school_weekly_rate_cents ,
                      :full_time_preschool_weekly_rate_cents,
                      :_destroy
                   ]

                  )
  end
end
