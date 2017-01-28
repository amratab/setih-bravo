class PagesController < ApplicationController

  def about
    redirect_to projects_path unless current_user.nil?
  end

end
