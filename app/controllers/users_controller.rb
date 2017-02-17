class UsersController < ApplicationController
  before_filter :authorize, only: [:profile, :update]

  def profile
    @skills           = Skill.all.map{|s| {id: s.id, name: s.name}}.to_json.html_safe
    @volunteer_skills = if current_user.volunteer_profile.present?
      current_user.volunteer_profile.skills.pluck(:id).to_json.html_safe
    else
      [].to_json
    end
    @requests         = current_user.requests
    @requested_skills = if current_user.requests.present?
      current_user.requests.first.skills.pluck(:id).to_json.html_safe
    else
      [].to_json
    end
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
      flash[:success] = "Thanks for signing up!"
      redirect_to profile_users_path
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to :back
    end
  end

  def update
    user = current_user
    user.update(params.require(:user).permit(:email, :first_name, :last_name, :phone))
    flash[:success] = "Successfully updated profile"
    redirect_to profile_users_path
  end

end
