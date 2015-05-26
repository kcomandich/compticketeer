class TicketKindsController < ApplicationController
  before_filter :assign_event_or_redirect, only: [:new, :edit, :show]
  before_filter :assign_tickets_or_redirect, only: [:new, :edit, :show]

  # GET /ticket_kinds
  def index
    @ticket_kinds = TicketKind.ordered
  end

  # GET /ticket_kinds/1
  def show
    @ticket_kind = TicketKind.find(params[:id])
  end

  # GET /ticket_kinds/new
  def new
    @ticket_kind = TicketKind.new
  end

  # GET /ticket_kinds/1/edit
  def edit
    @ticket_kind = TicketKind.find(params[:id])
  end

  # POST /ticket_kinds
  def create
    @ticket_kind = TicketKind.new(ticket_kinds_params)

    if @ticket_kind.save
      flash[:notice] = 'TicketKind was successfully created.'
      redirect_to(@ticket_kind)
    else
      render action: "new"
    end
  end

  # PUT /ticket_kinds/1
  def update
    @ticket_kind = TicketKind.find(params[:id])

    if @ticket_kind.update_attributes(ticket_kinds_params)
      flash[:notice] = 'TicketKind was successfully updated.'
      redirect_to(@ticket_kind)
    else
      render action: "edit"
    end
  end

  # DELETE /ticket_kinds/1
  def destroy
    @ticket_kind = TicketKind.find(params[:id])
    @ticket_kind.destroy

    redirect_to(ticket_kinds_url)
  end

  private

  def ticket_kinds_params
    params.require(:ticket_kind).permit(:title, :prefix, :template, :subject, :eventbrite_ticket_id, :is_access_code, :created_at, :updated_at)
  end
end
