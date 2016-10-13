class ChildrenController < ApplicationController
  def show
    @family = Family.find(params[:family_id])
    @child = Child.find(params[:id])
  end
end
