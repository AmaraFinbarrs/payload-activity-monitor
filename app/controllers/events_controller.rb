# app/controllers/events_controller
class EventsController < ApplicationController
  include ErrorHandlers
  before_action :check_for_bad_request, :check_for_unprocessable_entity
  before_action :user
  before_action :codes, only: %i[check_alerts]

  rescue_from StandardError, with: :render_internal_server_error

  def index; end

  def check_alerts
    render json: { alert: codes.any?,
                   alert_codes: codes,
                   user_id: event_params[:user_id] }
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
    return unless withdrawal?

    event_params[:amount].to_i > 100
  end

  def consecutive_withdrawal_3_counts?
    # Reset consecutive withdrawals to 0 if there's a deposit
    if deposit?
      (user.consecutive_withdrawals.zero? || user.update(consecutive_withdrawals: 0)) && false
    elsif withdrawal?
      # Handle consecutive withdrawals
      if user.consecutive_withdrawals == 2
        user.update(consecutive_withdrawals: 0) && true
      else
        user.consecutive_withdrawals += 1
        user.save && false
      end
    end
  end

  def asc_deposit_3_counts?
    return false unless deposit?

    # Check if deposit amount is ascending
    if event_params[:amount].to_f > user.current_deposit
      if user.asc_deposit_count == 2
        # Reset the count if the deposit is ascending 3 times in a row
        user.update(current_deposit: event_params[:amount].to_f, asc_deposit_count: 0) && true
      else
        # Increment the count if the deposit is ascending but less than 3 counts
        user.asc_deposit_count += 1
        user.save && false
      end
    end
  end

  def deposit_30s_sum_exceeds_200?
    return false unless deposit?

    amount = event_params[:amount].to_f

    if user.deposit_30s_start_time.nil?
      # Initialize sum and start time for the first deposit
      user.update(deposit_30s_start_time: Time.now, deposit_30s_sum: amount)
      return false
    end

    # Check if the deposit is within the 30-second window
    if Time.now - user.deposit_30s_start_time <= 30
      # Accumulate the amount within the window
      new_sum = user.deposit_30s_sum + amount

      # Check if the new sum exceeds 200
      if new_sum > 200
        true
      else
        user.update(deposit_30s_sum: new_sum)
        false
      end
    else
      # Reset the start time and sum if the window is exceeded
      user.update(deposit_30s_start_time: Time.now, deposit_30s_sum: amount)
      false
    end
  end

  # Helper Methods
  def event_params
    params.permit(:type, :amount, :user_id, :time)
  end

  def withdrawal?
    event_params[:type].downcase == 'withdrawal'
  end

  def deposit?
    event_params[:type].downcase == 'deposit'
  end

  def user
    User.find_or_create_by(id: event_params[:user_id].to_i)
  end

  # Perform validation checks on the request parameters
  def check_for_bad_request
    if event_params[:type].nil? && event_params[:amount].nil? && event_params[:user_id].nil? && event_params[:time].nil?
      render_bad_request('Required parameter missing') and return
    end
    if !number?(event_params[:amount])
      render_bad_request('Amount must be a number.') and return
    elsif !number?(event_params[:user_id])
      render_bad_request('User ID must be a number.') and return
    elsif !number?(event_params[:time])
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
