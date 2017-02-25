class RequestsController < ApplicationController
  before_filter :set_request_context, except: [:index, :new, :create]
  before_filter :verify_eligibility, only: [:edit, :update, :deactivate]

  def index
    @requests = Request.active.includes(:user, :skills).order(:created_at)
    @skills   = Skill.joins(skill_joins: :request).merge(Request.active)
    @urgencies = @requests.pluck('distinct urgency')
  end

  def show
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
        session[:user_id] = user.id
        flash[:success] = "Your request was received! Now check out our awesome volunteers!"
        redirect_to volunteer_profiles_path
      end
    rescue => e
      flash[:error] = "Sorry #{e.message}"
      redirect_to :back
    end
  end

  def edit
    @skills           = Skill.all.map{|s| {id: s.id, name: s.name}}.to_json.html_safe
    @requested_skills = @request.skills.pluck(:id).to_json.html_safe
  end

  def update
    @request.update(params.require(:request).permit(:description, :purpose, :urgency))
    @request.update(is_active: true)
    org = @request.organization
    org.update(params.require(:organization).permit(:name))
    org.url = scrub_url(params.require(:organization).permit(:url)[:url])
    org.save

    skills = Skill.where(id: params[:request][:skills].split(',')).sort

    if @request.skills.sort != skills
      @request.skills.delete(@request.skills - skills)
      @request.skills << (skills - @request.skills)
    end

    flash[:success] = "Your request has been updated!"
    redirect_to edit_request_path(@request)
  end

  def toggle_activation
    prev_status = @request.is_active
    @request.update(is_active: !prev_status)
    flash[:success] = "Successfully updated the status of this request."
    redirect_to edit_request_path(@request)
  end

  private

  def set_request_context
    @request = Request.find_by_id(params[:id])
    if @request.nil?
      flash[:error] = "Sorry, request not found!"
      redirect_to :back and return
    end
  end

  def verify_eligibility
    if current_user != @request.user
      flash[:error] = "Sorry, request not found!"
      redirect_to :back and return
    end
  end

end
