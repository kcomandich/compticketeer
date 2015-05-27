class ApplicationController < ActionController::Base
  helper :all
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :require_user

  protected

  #==[ Utilities ]==============================================================

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  helper_method :current_user_session

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  helper_method :current_user

  #==[ Filters ]================================================================

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Set @event variable
  def assign_event
    @event = Event.find_or_create_by(eventbrite_event_id: Rails.application.config.eventbrite[:event_id])
    @event.get_event
    if @event.error
      flash[:error] = @event.error
    end
  end

  def assign_event_or_redirect
    assign_event
    if flash[:error]
      redirect_to config_url
    end
  end

  def assign_tickets_or_redirect
    @eventbrite_tickets = @event.eventbrite_free_hidden_tickets
    unless @eventbrite_tickets
      redirect_to config_url
    end
  end
end
