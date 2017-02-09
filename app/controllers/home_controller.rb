#
# HomeController
#
class HomeController < ApplicationController
  # -----------------------------------------------------------------
  # const
  # -----------------------------------------------------------------
  ENDPOINTS = [:index, :terms, :privacy, :contact, :support, :about].freeze

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

  def contact
  end

  def support
  end

  def about
  end
end
