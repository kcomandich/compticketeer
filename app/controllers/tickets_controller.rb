class TicketsController < ApplicationController
  before_filter :assign_event, only: [:index]

  # GET /tickets
  def index
    @tickets = Ticket.ordered
  end

  # GET /tickets/1
  def show
    @ticket = Ticket.find(params[:id])
  end
end
