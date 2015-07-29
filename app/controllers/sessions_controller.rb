class SessionsController < ApplicationController
  def new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
  	render user
  else
    flash[:danger] = 'Invalid email/password combination' 
    render 'new'

    end
  end

  def destroy
  end
end
