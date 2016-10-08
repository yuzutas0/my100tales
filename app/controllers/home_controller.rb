#
# HomeController
#
class HomeController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  skip_before_action :authenticate_user!, only: [:index]

  # -----------------------------------------------------------------
  # endpoint
  # -----------------------------------------------------------------
  def index
  end
end
