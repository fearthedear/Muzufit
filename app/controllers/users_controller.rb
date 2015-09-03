class UsersController < ApplicationController
before_action :logged_in_user, only: [:show, :edit, :update]
before_action :correct_user, only: [:edit, :update]
	def new
		@user = User.new
	end



	def show
		@user = User.find(params[:id])
    @template = Template.new
    if @user.company
    @cpostings = current_user.cpostings.where.not(starts_at: nil)
    else

    end
	end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
			UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end




    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

end
