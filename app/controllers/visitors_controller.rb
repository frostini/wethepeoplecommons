class VisitorsController < ApplicationController

  def create
    visitor = Visitor.new(params.require(:visitor).permit(:email, :group))
    if visitor.save
      if params[:group] == "Requester"
        flash[:success] = "Email updated, now let's fill out your request info!"
        redirect_to requester_path(visitor_id: visitor_id)
      else
        flash[:success] = "Email updated, now let's fill out your volunteer info!"
        redirect_to volunteer_path(visitor_id: visitor_id)
      end
    else
      flash[:error] = "Sorry, Your #{visitor.errors.full_messages.to_sentence}. Please Try Again."
      redirect_to :back
    end
  end

end
