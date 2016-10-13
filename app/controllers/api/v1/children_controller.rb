class Api::V1::ChildrenController < ApiController
  before_filter :find_child, only: [:show, :edit, :destroy, :update]
  has_scope :by_family, as: :family_id

  # GET /childs.json
  def index
    @children = api_scopes(Child)
    render json: @children, each_serializer: ChildrenSerializer
  end

  def create
    @child = Child.new(child_params)
    if @child.save
      render json: @child
    else
      render_error(@child)
    end
  end

  def update
    @child.update_attributes(child_params)
    @child.save ? render(json: @child) : render_error(@child)
  end

  def destroy
    @child.destroy ? render_success : render_error
  end

  private

  def find_child
    @child = Child.find(params[:id])
  end

  def child_params
    params[:child] = params[:childre]
    params.require(:child).permit(
      :relationship,
      :first_name,
      :last_name,
      :date_of_birth,
      :gender,
      :race,
      :family_id,
      :provider_id,
      :weekly_maximum_payout
    )
  end
end
