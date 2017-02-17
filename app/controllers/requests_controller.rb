class RequestsController < ApplicationController

  def index
    @requests = Request.includes(:user, :skills)
    @skills   = Skill.joins(skill_joins: :request).merge(Request.active)
    @urgencies = @requests.pluck('distinct urgency')
  end

  def show
    @request  = Request.find_by_id(params[:id])
    unless @request.present?
      flash[:error] = "Sorry, volunteer not found!"
      redirect_to :back
    end
  end

  def new
    @visitor = Visitor.find_by_id(params[:visitor_id])
    @skills  = Skill.all.map{|s| {id: s.id, name: s.name}}.to_json.html_safe
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        if current_user.nil?
          visitor = Visitor.find_by_email(params[:user][:email])
          user    = User.new(params.require(:user).permit(:email, :password, :first_name, :last_name, :phone))
          user.visitor_id = visitor.id if visitor.present?
          user.save!
        else
          user = current_user
        end

        organization = if params[:organization].present?
          org = Organization.new(params.require(:organization).permit(:name))
          org.url = scrub_url(params.require(:organization).permit(:url)[:url])
          org.save!
          org
        end

        request         = Request.new(params.require(:request).permit(:description, :purpose, :urgency))
        request.user_id = user.id
        request.organization_id = organization.id if organization.present?
        request.save!

        # do some skill mapping
        skills = Skill.where(id: params[:request][:skills].split(','))
        request.skills << skills

        UserMailer.send_request_confirmation(request.id).deliver_now

        flash[:success] = "Your request have been received! Please expect an email from us soon!"
        redirect_to :back
      end
    rescue => e
      flash[:error] = "Sorry #{e.message}"
      redirect_to :back
    end
  end

  def update
    profile = current_user.volunteer_profile
    profile.update(params.require(:volunteer).permit(:interest, :bio))

    skills = Skill.where(id: params[:volunteer][:skills].split(',')).sort

    if profile.skills.sort != skills
      skills.delete(profile.skills - skills)
      profile.skills << (skills - profile.skills)
    end

    flash[:success] = "Your request has been updated!"
    redirect_to :profile_users_path
  end

end
