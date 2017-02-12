class UsersController < ApplicationController
  before_filter :authorize, only: [:show, :update]

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(params.require(:user).permit(:email, :password, :first_name, :last_name))
    # If the user exists AND the password entered is correct.
    if user.save
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      flash[:success] = "Welcome back!"
      redirect_to user_path(user)
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to :back
    end
  end

  def update
  end

end
