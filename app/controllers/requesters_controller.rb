class RequestersController < ApplicationController

  def new
    if params[:visitor_id].present?
      @visitor = Visitor.find_by_id(params[:visitor_id])
    end
  end

end
