class TicketsController < ApplicationController

  # GET /tickets
  def index
    @tickets = Ticket.ordered
  end

  # GET /tickets/1
  def show
    @ticket = Ticket.find(params[:id])
  end
end
