class RequestsController < ApplicationController

  def new
    if params[:visitor_id].present?
      @visitor = Visitor.find_by_id(params[:visitor_id])
    end

    @request = Request.new
    @skills = Skill.all.map{|s| {id: s.id, name: s.name}}.to_json.html_safe
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        visitor = Visitor.find_by_email(params[:user][:email])
        user = User.new(params.require(:user).permit(:email, :password, :first_name, :last_name, :phone))
        user.visitor_id = visitor.id if visitor.present?
        user.save!

        organization = if params[:organization].present?
          org = Organization.new(params.require(:organization).permit(:name))
          org.url = scrub_url(params.require(:organization).permit(:url)[:url])
          org.save!
          org
        end

        request = Request.new(params.require(:request).permit(:description, :purpose, :urgency))
        request.user_id = user.id
        request.organization_id = organization.id if organization.present?
        request.save!

        # do some skill mapping
        skills = Skill.where(id: params[:request][:skills].split(','))
        request.skills << skills
        flash[:success] = "Your request have been received! Please expect an email from us soon!"
        redirect_to :back
      end
    rescue => e
      flash[:error] = "Sorry #{e.message}"
      redirect_to :back
    end
  end

end
