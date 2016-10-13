class SettingsController < ApplicationController
  before_filter :admin_only

  def index
    @child_care_rates = CountyRate.joins(:provider_type)
                                  .includes(:county)
                                  .where(provider_type_id: 1)
                                  .order(:id)
    @daily_care_rates = CountyRate.joins(:provider_type)
                                  .includes(:county)
                                  .where(provider_type_id: 2)
                                  .order(:id)
    @group_care_rates = CountyRate.joins(:provider_type)
                                  .includes(:county)
                                  .where(provider_type_id: 3)
                                  .order(:id)
  end

  def update_county_rate
    county_rate = CountyRate.find(params[:id])
    county_rate.update_attributes(county_rate_params)
    redirect_to settings_path
  end

  def county_rate_params
    params.require(:county_rate).permit(
      :part_time_toddler_weekly_rate,
      :full_time_toddler_weekly_rate,
      :part_time_infant_weekly_rate,
      :full_time_infant_weekly_rate,
      :part_time_school_weekly_rate,
      :full_time_school_weekly_rate,
      :part_time_preschool_weekly_rate,
      :full_time_preschool_weekly_rate
    )
  end
end