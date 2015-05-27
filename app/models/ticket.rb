class Ticket < ActiveRecord::Base
  belongs_to :batch
  belongs_to :ticket_kind
  belongs_to :event

  scope :ordered, -> { order('created_at desc').includes(:ticket_kind) }

  # Validations
  validates_presence_of :batch
  validates_presence_of :ticket_kind
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create

  # Callbacks
  before_validation :set_ticket_kind
  before_validation :generate_discount_code

  # Disable the registration of codes during tests?
  cattr_accessor :disable_register_code

  # Acts As State Machine
  include AASM
  aasm column: :status do
    state :created, initial: true
    state :registering_code
    state :registered_code
    state :failed_to_register_code
    state :sending_email
    state :sent_email
    state :failed_to_send_email

    event :registering_code        do transitions from: :created,          to: :registering_code end
    event :registered_code         do transitions from: :registering_code, to: :registered_code end
    event :failed_to_register_code do transitions from: :registering_code, to: :failed_to_register_code end
    event :sending_email           do transitions from: :registered_code,  to: :sending_email end
    event :sent_email              do transitions from: :sending_email,    to: :sent_email end
    event :failed_to_send_email    do transitions from: :sending_email,    to: :failed_to_send_email end
  end

  # Return human-readable label for status.
  def status_label
    label = self.status.to_s.gsub('created', 'working').gsub(/_/, ' ').capitalize
    label << '...' unless self.done?
    label << '!' if self.success? == false
    return label
  end

  # Is the ticket processing done, be it success or failure?
  def done?
    return [:failed_to_register_code, :failed_to_send_email, :sent_email].include?(self.status.try(:to_sym))
  end

  # Was the ticket processed successfully? True if yes, false if failed, nil if not finished.
  def success?
    return self.done? ?
      self.status.to_sym == :sent_email :
      nil
  end

  # Set this ticket's kind if needed and one's available in the batch.
  def set_ticket_kind
    if self.ticket_kind.nil? && self.batch && self.batch.ticket_kind
      self.ticket_kind = self.batch.ticket_kind
    end
  end

  # Generate a discount code for this ticket.
  def generate_discount_code
    if self.discount_code.nil? && self.email.present?
      # Add a prefix to the ticket if possible
      s = self.ticket_kind ? (self.ticket_kind.prefix + '_') : ''
      # Generate a discount code based on the user's email
      salted_email = "#{self.email} #{Rails.application.secrets.discount_code_salt}"
      email_hash = Digest::MD5.hexdigest(salted_email)[0..6]
      email_fragment = self.email.gsub(/\W/, '')
      s << "#{email_fragment}_#{email_hash}"
      self.discount_code = s
    end
  end

  # Process this ticket and return the status.
  def process
    self.ticket_kind.is_access_code ? self.register_access_code : self.register_discount_code
    if self.registered_code?
      self.send_email
    end
    return self.status
  end

  # Register the access code with Eventbrite.
  def register_access_code
    self.registering_code!
    if self.class.disable_register_code
      self.registered_code!
      return false
    end

    return false unless valid_secrets?

    status, message = Eventbrite.new_access_code(self.discount_code, self.ticket_kind.eventbrite_ticket_id)
    status ? self.registered_code! : self.failed_to_register_code!
    self.update_attribute :report, message

    return status
  end

  # Register the discount code with Eventbrite.
  def register_discount_code
    self.registering_code!
    if self.class.disable_register_code
      self.registered_code!
      return false
    end

    return false unless valid_secrets?

    status, message = Eventbrite.new_discount_code(self.discount_code, self.ticket_kind.eventbrite_ticket_id)
    status ? self.registered_code! : self.failed_to_register_code!
    self.update_attribute :report, message

    return status
  end

  def valid_secrets?
    unless Rails.application.config.eventbrite[:oauth_token]
      self.update_attribute :report, "Couldn't register Eventbrite code because no OAuth token was defined in 'config/initializers/eventbrite.rb'"
      self.failed_to_register_code!
      logger.warn "Couldn't register Eventbrite code because no OAuth token was defined in 'config/initializers/eventbrite.rb'"
      return false
    end
    return true
  end

  # Send email for this ticket.
  def send_email
    self.sending_email!
    begin
      ApplicationMailer.ticket_email(self).deliver # TODO use deliver_later when upgraded to Rails 4.2
    rescue Exception => e
      # TODO catch specific exception?
      self.update_attribute :report, "Could not send email: #{e.class.name}, #{e.message}"
      self.failed_to_send_email!
    else
      self.sent_email!
    end
  end

  # Return a filled-in template for email.
  def fill_email_template
    return self.ticket_kind.template.gsub(/%CODE%/i, self.discount_code)
  end
end
