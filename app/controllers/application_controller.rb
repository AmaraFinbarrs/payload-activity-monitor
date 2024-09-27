class ApplicationController < ActionController::API
  include ErrorHandlers

  def raise_not_found
    raise ActionController::RoutingError, 'Page or action does not exit'
  end
end
