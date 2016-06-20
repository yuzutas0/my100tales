#
# HomeController
#
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    render :layout => 'landing'
  end
end
