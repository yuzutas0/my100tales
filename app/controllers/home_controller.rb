#
# HomeController
#
class HomeController < ApplicationController
  # -----------------------------------------------------------------
  # const
  # -----------------------------------------------------------------
  ENDPOINTS = [:index, :terms, :privacy, :about, :contact].freeze

  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  skip_before_action :authenticate_user!, only: ENDPOINTS

  # -----------------------------------------------------------------
  # endpoint
  # -----------------------------------------------------------------
  def index
  end

  def terms
  end

  def privacy
  end

  def about
  end

  def contact
  end
end
