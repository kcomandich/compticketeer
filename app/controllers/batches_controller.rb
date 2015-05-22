class BatchesController < ApplicationController
  before_filter :assign_ticket_kinds_or_redirect, only: [:new, :create, :index, :show]
  before_filter :assign_event_or_redirect, only: [:new]

  # GET /batches
  def index
    @batches = Batch.ordered
  end

  # GET /batches/1
  def show
    @batch = Batch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        render json: @batch.to_json(
          methods: [:done?],
          include: {
            tickets: {methods: [:status_label, :done?, :success?]}
          }
        )
      end
    end
  end

  # GET /batches/new
  def new
    @batch = Batch.new
    @eventname = @event.title
  end

  # POST /batches
  def create
    @batch = Batch.new(batch_params)

    if @batch.save
      @batch.process_asynchronously
      flash[:notice] = 'Batch was successfully created.'
      redirect_to(@batch)
    else
      render action: "new"
    end
  end

  # DELETE /batches/1
  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy

    redirect_to(batches_path)
  end

  protected

  # Set @ticket_kinds variable or redirect to new ticket kind form if none are available.
  def assign_ticket_kinds_or_redirect
    if TicketKind.count == 0
      flash[:error] = "You must create at least one kind of ticket before creating tickets."
      redirect_to new_ticket_kind_path
    else
      @discount_ticket_kinds = TicketKind.discount_kinds.ordered
      @access_ticket_kinds = TicketKind.access_kinds.ordered
    end
  end

  private

  def batch_params
    params.require(:batch).permit(:emails, :ticket_kind_id, :created_at)
  end
end
