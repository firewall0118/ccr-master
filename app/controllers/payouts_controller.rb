class PayoutsController < ApplicationController
  def destroy
    @payout = Payout.find(params[:id])
    @payout.destroy
    redirect_to :back, success: "Payout was deleted."
  end
end
