class ApplicationController < ActionController::API
  include ErrorHandlers

  def raise_not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
