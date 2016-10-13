class Api::V1::ProviderAttendancesController < ApiController
  before_filter :find_attendance, only: [:update]
  has_scope :by_year, as: :year
  has_scope :by_month, as: :month
  has_scope :by_provider, as: :provider_id

  def index
    @attendances = api_scopes(ProviderAttendance.includes(contract: [:funder, :family, :child, :provider]))
    render json: @attendances
  end

  def update
    @attendance.update_attributes(attendance_params)
    @attendance.save ? render(json: @attendance) : render_error(@attendance)
  end

  private

  def find_attendance
    @attendance = ProviderAttendance.find(params[:id])
  end

  def attendance_params
    params.require(:provider_attendance).permit(:days)
  end
end
