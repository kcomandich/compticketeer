class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_FROM_ADDRESS']

  def self.configured?
    hostname = ENV['MAILER_ADDRESS']
    return(hostname.present? && hostname != 'test')
  end

  def ticket_email(ticket, sent_at = Time.now)
    unless self.class.configured?
      raise ArgumentError, "Email settings for must be set in the environment"
    end
    mail(to: ticket.email, subject: ticket.ticket_kind.subject) do |format|
      format.text { render text: ticket.fill_email_template }
    end
  end
end
