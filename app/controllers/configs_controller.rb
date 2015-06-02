class ConfigsController < ApplicationController
  before_filter :assign_event

  # GET /config
  def show
    @eb_config = Rails.application.config.eventbrite
    @mail_config = Rails.application.config.action_mailer.smtp_settings
  end
end
