class VolunteerProfilesController < ApplicationController
  before_filter :authorize, only: [:update]

  def index
    @profiles = VolunteerProfile.includes(:user, :skills)
    @skills   = Skill.joins(skill_joins: :volunteer_profile)
  end

  def show
    @profile  = VolunteerProfile.find_by_id(params[:id])
    unless @profile.present?
      flash[:error] = "Sorry, volunteer not found!"
      redirect_to :back
    end
  end

  def new
    if current_user.present? && current_user.volunteer_profile.present?
      redirect_to profile_users_path and return
    end

    if params[:visitor_id].present?
      @visitor = Visitor.find_by_id(params[:visitor_id])
    end

    @skills = Skill.all.map{|s| {id: s.id, name: s.name}}.to_json.html_safe
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        if current_user.nil?
          visitor = Visitor.find_by_email(params[:user][:email])
          user = User.new(params.require(:user).permit(:email, :password, :first_name, :last_name, :phone))
          user.visitor_id = visitor.id if visitor.present?
          user.save!
        else
          user = current_user
        end

        profile = VolunteerProfile.new(params.require(:volunteer).permit(:interest, :bio))
        profile.user_id = user.id
        profile.save!

        # do some skill mapping
        skills = Skill.where(id: params[:volunteer][:skills].split(','))
        profile.skills << skills

        UserMailer.send_volunteer_confirmation(profile.id).deliver_now

        session[:user_id] = user.id

        flash[:success] = "Thanks signing up! Now check out some of our requests!"
        redirect_to :requests_path
      end
    rescue => e
      flash[:error] = "Sorry #{e.message}"
      redirect_to :back
    end
  end

  def update
    user = current_user
    user.update(params.require(:user).permit(:email, :first_name, :last_name, :phone))

    profile = user.volunteer_profile
    profile.update(params.require(:volunteer).permit(:interest, :bio))

    skills = Skill.where(id: params[:volunteer][:skills].split(',')).sort

    if profile.skills.sort != skills
      profile.skills.delete(profile.skills - skills)
      profile.skills << (skills - profile.skills)
    end

    flash[:success] = "Your profile has been updated!"
    redirect_to profile_users_path
  end
end
