class Batch < ActiveRecord::Base
  has_many :tickets, dependent: :destroy
  belongs_to :ticket_kind

  scope :ordered, -> { order('created_at asc') }

  validates_presence_of :ticket_kind_id
  validates_presence_of :emails

  before_validation :create_tickets
  after_validation :validate_tickets

  # Process all tickets.
  def process
    tickets.each { |t| t.process }
  end

  # Process all tickets asynchronously.
  def process_asynchronously
    # TODO temporary fix until I can use ActiveJob when I upgrade to Rails 4.2
    # Rails 2.3 code: spawn { self.process }
    tickets.each { |t| t.process }
  end

  # Is processing on all the tickets done?
  def done?
    self.tickets.each do |ticket|
      return false unless ticket.done?
    end
    return true
  end

  protected

  # Create the tickets associated with this batch.
  def create_tickets
    self.emails.split(/\s+/).map(&:strip).each do |email|
      if ticket = self.tickets.detect {|ticket| ticket.email == email }
        ticket.update_attributes(ticket_kind: self.ticket_kind, batch: self)
      else
        ticket = Ticket.new(email: email, ticket_kind: self.ticket_kind, batch: self, event_id: Rails.application.secrets.eventbrite_data['event_id'])
        self.tickets << ticket
      end
      Ticket.where(email: email, event_id: Rails.application.secrets.eventbrite_data['event_id']).each do |prev_ticket|
        # TODO how to pass this message to controller/view
        logger.warn "Warning: This email [#{email}] already has a #{prev_ticket.ticket_kind.title.upcase} ticket code, emailed status = #{prev_ticket.status.to_s.upcase} for this event."
      end
    end
  end

  # Validate the associated tickets and add validation errors if needed.
  def validate_tickets
    # NOTE: This strange method is run at the end of validation and replaces
    # the vague "Tickets is invalid" validation error with more useful messages
    # that explain what tickets had what errors.
    if self.errors[:tickets]
      self.instance_variable_get(:@errors).delete(:tickets)
      self.tickets.each do |ticket|
        next if ticket.valid?
        self.errors.add(:base, "Ticket with address '#{ticket.email}': " + ticket.errors.full_messages.join(', '))
      end
    end
  end
end
