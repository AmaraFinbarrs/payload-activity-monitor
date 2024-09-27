class EventsController < ApplicationController
  def index
    app = true
    if app
      result = {
        name: 'Event',
        description: 'This is an event',
        purpose: 'To test the API'
      }
      render json: result, status: :ok
    else
      render_not_found
      # render json: { error: 'Not Found' }, status: :not_found
    end
  end
end
