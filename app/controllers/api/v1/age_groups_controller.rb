class Api::V1::AgeGroupsController < ApiController
  before_filter :find_age_group, only: [:show, :edit, :destroy, :update]

  # GET /age_groups.json
  def index
    @age_groups = AgeGroup.all.order(:created_at)

    render json: @age_groups
  end

  def create
    if @age_group.save
      render json: @age_group
    else
      render_error(@age_group)
    end
  end

  def update
    @age_group.update_attributes(age_group_params)
    @age_group.save ? render(json: @age_group) : render_error(@age_group)
  end

  def destroy
    @age_group.destroy ? render_success : render_error
  end

  private

  def find_age_group
    @age_group = AgeGroup.find(params[:id])
  end

  def age_group_params
    params.require(:age_group).permit(:min, :max)
  end

end
