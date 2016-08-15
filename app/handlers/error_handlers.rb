# error_handlers
module ErrorHandlers
  extend ActiveSupport::Concern

  # 404
  def render_404
    if request.xhr? || params[:format] == :json
      render json: { error: '404 error' }, status: 404
    else
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end
  end
end
