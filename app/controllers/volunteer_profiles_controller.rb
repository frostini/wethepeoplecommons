class VolunteerProfilesController < ApplicationController

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
    if params[:visitor_id].present?
      @visitor = Visitor.find_by_id(params[:visitor_id])
    end

    @skills = Skill.all.map{|s| {id: s.id, name: s.name}}.to_json.html_safe
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        visitor = Visitor.find_by_email(params[:user][:email])
        user = User.new(params.require(:user).permit(:email, :password, :first_name, :last_name, :phone))
        user.visitor_id = visitor.id if visitor.present?
        user.save!

        profile = VolunteerProfile.new(params.require(:volunteer).permit(:interest, :bio))
        profile.user_id = user.id
        profile.save!

        # do some skill mapping
        skills = Skill.where(id: params[:volunteer][:skills].split(','))
        profile.skills << skills

        UserMailer.send_volunteer_confirmation(profile.id).delideliver_now

        flash[:success] = "Thanks signing up! Please expect an email from us soon!"
        redirect_to :back
      end
    rescue => e
      flash[:error] = "Sorry #{e.message}"
      redirect_to :back
    end
  end
end
