class AccountsController < ApplicationController
  before_filter :admin_only

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User was created successfully.'
      redirect_to accounts_path
    else
      flash[:error] = "Couldn't create the user."
      render action: 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    successfully_updated = if needs_password?
                             @user.update(user_params)
                           else
                             @user.update_without_password(user_params)
                           end

    if successfully_updated
      flash[:success] = 'User was updated successfully.'
      redirect_to account_path(@user)
    else
      flash[:error] = "Couldn't update the user."
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to accounts_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :permission_level)
  end

  def needs_password?
    user_params[:password].present?
  end
end
