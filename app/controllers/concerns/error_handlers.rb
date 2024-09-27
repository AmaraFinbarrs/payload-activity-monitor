module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    # Manage Random Routes
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  private

  def render_bad_request
    render json: { error: 'Bad request. The endpoint does not exist or the request is malformed.' }, status: :bad_request
  end

  def render_unprocessable_entity
    render json: { error: 'Unprocessable entity. Check the request data.' }, status: :unprocessable_entity
  end

  def render_internal_server_error
    render json: { error: 'Internal server error. Please try again later.' }, status: :internal_server_error
  end

  def render_not_found(exception = nil)
    render json: { error: "Resource not found." }, status: :not_found
  end
end
