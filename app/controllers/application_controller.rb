class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_found
    render :partial => "shared/not_found"
  end
end
