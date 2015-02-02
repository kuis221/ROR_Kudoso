class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter :set_time_zone

  helper_method :format_counter
  helper_method :format_counter_min

  def format_counter(seconds)
    sec = seconds % 60
    min = (seconds/60).floor
    hours = (min/60).floor
    if hours > 0
      min = min - (hours * 60)
      "#{hours}:#{sprintf('%02d', min)}:#{sprintf('%02d', sec)}"
    else
      "#{min}:#{sprintf('%02d', sec)}"
    end
  end
  def format_counter_min(seconds)
    sec = seconds % 60
    min = (seconds/60).ceil
    hours = (min/60).floor
    if hours > 0
      min = min - (hours * 60)
      "#{hours}:#{sprintf('%02d', min)}"
    else
      "00:#{min}"
    end
  end

  # Authentication
  rescue_from CanCan::AccessDenied do |exception|
    if member_signed_in?
      Rails.logger.info "Access denied for member: #{current_member.id}"
    else
      Rails.logger.info "Access denied for anonymous member"
    end
    message = member_signed_in? ? 'You are not authorized to do that!' : 'You must be logged in to do that.'

    flash[:error] = message
    redirect_to (member_signed_in? ? [current_member.family, current_member] : new_user_session_path) #and return

  end

  def current_ability
    if member_signed_in?
      @current_ability ||= Ability.new(current_member)
    else
      @current_ability ||= Ability.new(current_user)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :username, :password, :password_confirmation, :first_name, :last_name, :parent, :family_id) }
  end

  private

  def set_time_zone
    if current_member && current_member.family && current_member.family.timezone
      Time.zone = ActiveSupport::TimeZone[current_member.family.timezone]
      logger.info "Set timezone to #{Time.zone}"
    end
  end




end
