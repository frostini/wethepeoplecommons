class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      flash[:success] = "Welcome back!"
      if request.referrer.include?("requests") || request.referrer.include?("volunteer")
        redirect_to :back
      else
        redirect_to profile_users_path
      end
    else
    # If user's login doesn't work, send them back to the login form.
      flash[:error] = "Sorry, your email or password is not correct."
      redirect_to :back
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
