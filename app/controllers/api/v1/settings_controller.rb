class Api::V1::SettingsController < ApiController
  before_filter :find_setting, only: [:update]

  # GET /settings.json
  def show
    @setting = Setting.first
    render json: @setting
  end

  def update
    @setting.update_attributes(setting_params)
    @setting.save ? render(json: @setting) : render_error(@setting)
  end

  private
  def setting_params
    params.require(:setting)
          .permit(:alabama_minimum_wage, :minimum_work_hours, :fiscal_year_start, :fiscal_year_end)
  end

  def find_setting
    @setting = Setting.find(params[:id])
  end
end
