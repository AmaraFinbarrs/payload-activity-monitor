# app/controllers/events_controller
class EventsController < ApplicationController
  before_action :check_for_bad_request, :check_for_unprocessable_entity

  def index
    event_params
  end

  def check_alerts
    render json: { alert: codes.any?,
                   alert_codes: codes,
                   user_id: id }
  end

  private

  def codes
    codes = []

    codes << '1100' if withdrawal_exceeds_100?
    codes << '30' if consecutive_withdrawal_3_counts?
    codes << '300' if asc_deposit_3_counts?
    codes << '123' if deposit_30s_sum_exceeds_200?

    codes
  end

  # Predefined Rules for Alerts
  def withdrawal_exceeds_100?
    true
  end

  def consecutive_withdrawal_3_counts?
    true
  end

  def asc_deposit_3_counts?
    true
  end

  def deposit_30s_sum_exceeds_200?
    true
  end

  # Helper Methods
  def event_params
    params.permit(:type, :amount, :user_id, :time)
  end

  def id
    event_params[:user_id]
  end

  # Perform validation checks on the request parameters
  def check_for_bad_request
    if !number?(event_params[:amount])
      render_bad_request('Amount must be a number.') and return
    elsif !number?(event_params[:user_id])
      render_bad_request('User ID must be a number.') and return
    elsif integer?(event_params[:time])
      render_bad_request('Time must be a number in seconds') and return
    end
  end

  def check_for_unprocessable_entity
    if %w[deposit withdrawal].exclude?(event_params[:type].downcase)
      render_unprocessable_entity('Must be deposit or withdrawal.') and return
    elsif event_params[:user_id].to_i <= 0
      render_unprocessable_entity('User ID must be a positive integer.') and return
    elsif event_params[:amount].to_i <= 0
      render_unprocessable_entity('Amount must be a positive integer.') and return
    elsif event_params[:time].to_i.negative?
      render_unprocessable_entity('Time must be a positive integer.') and return
    end
  end

  def number?(string)
    string.to_s.match?(/\A-?\d+(\.\d+)?\z/)
  end
end
