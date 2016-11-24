#
# HomeController
#
class HomeController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  skip_before_action :authenticate_user!, only: [:index, :privacy]

  # -----------------------------------------------------------------
  # endpoint
  # -----------------------------------------------------------------
  def index
  end

  def privacy
  end
end
