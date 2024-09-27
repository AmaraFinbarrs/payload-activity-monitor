module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    # Manage Random Routes
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  private

  def render_bad_request(exception = nil)
    render json: { error: "Bad request: #{exception}" }, status: :bad_request
  end

  def render_unprocessable_entity(exception = nil)
    render json: { error: "Unprocessable entity: #{exception}" }, status: :unprocessable_entity
  end

  def render_internal_server_error(exception = nil)
    render json: { error: "Internal server error: #{exception}" }, status: :internal_server_error
  end

  def render_not_found(exception = nil)
    render json: { error: "Resource not found: #{exception}" }, status: :not_found
  end
end
