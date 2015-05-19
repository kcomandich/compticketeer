require 'rails_helper'

describe BatchesController do

  before :each do
    login_as_admin
  end

  shared_examples_for "with or without ticket kinds" do
    # FIXME really
  end

  describe "with ticket kinds" do
    it_should_behave_like "with or without ticket kinds"

    before :each do
      @ticket_kinds = [create(:ticket_kind), create(:ticket_kind)]
    end

    describe "new" do
      it "expects to display new batch form" do
        get :new
        expect(response).to be_success
        expect(flash[:error]).to be_blank
      end
    end

    describe "create" do
      before do
        stub_ticket_mailer_secrets
      end

      it "expects to create batch when given valid params" do
        expect(
          lambda do
            post :create, batch: {ticket_kind_id: @ticket_kinds.first.id, emails: "foo@bar.com\nbaz@qux.org"}
          end
        ).to change(Ticket, :count).by(2)

        expect(response).to redirect_to(batch_path(assigns[:batch].id))
        expect(assigns[:batch]).to be_valid
        expect(flash[:error]).to be_blank

        assigns[:batch].tickets.each do |ticket|
          expect(ticket.report).to be_blank
          expect(ticket.status).to eq "sent_email"
        end
      end

      it "expects to not create a batch when given invalid params"  do
        attributes = attributes_for :batch, ticket_kind: nil
        post :create, batch: attributes

        expect(response).to be_success
        expect(assigns[:batch]).to_not be_valid
      end
    end

    describe "index" do
      it "expects to list empty set" do
        Batch.destroy_all
        get :index
        expect(response).to be_success
        assigns[:batches] == []
      end

      it "expects to list batches" do
        batches = [create(:batch), create(:batch)]
        get :index
        expect(response).to be_success
        assigns[:batches] == batches
      end
    end

    describe "show" do
      it "expects to show batch" do
        batch = create(:batch)
        get :show, id: batch.id
        expect(response).to be_success
        assigns[:batch] == batch
      end

      describe "for JSON" do
        before do
          @batch = create(:batch)
          @tickets = @batch.tickets
          @ticket = @tickets.first
          get :show, id: @batch.id, format: "json"
          @data = response_json
        end

        describe "for batch" do
          it "expects to include attributes" do
            expect(@data['ticket_kind_id']).to eq @batch.ticket_kind_id
          end

          it "expects to include selected methods" do
            expect(@data['done?']).to eq @batch.done?
          end

          it "expects to not include unselected methods" do
            expect(@data['ticket_kind']).to be_nil
          end
        end

        describe "for tickets" do
          before do
             @ticket_data = @data['tickets'].first
             @ticket = @batch.tickets.detect{ |ticket| ticket.id == @ticket_data['id'] }
          end

          it "expects to include attributes" do
            expect(@ticket_data['status']).to eq @ticket.status
          end

          it "expects to include selected methods" do
            expect(@ticket_data['status_label']).to eq @ticket.status_label
          end

          it "expects to not include unselected methods" do
            expect(@ticket_data['send_email']).to be_nil
          end
        end
      end
    end

    describe "destroy" do
      it "expects to destroy batch" do
        batch = create(:batch)
        delete :destroy, id: batch.id
        expect(response).to redirect_to(batches_path)
        assigns[:batch] == batch
        expect(Batch.exists?(batch.id)).to eq false
      end
    end
  end

  describe "without ticket kinds" do
    it_should_behave_like "with or without ticket kinds"

    describe "new" do
      it "expects to demand that ticket kinds be created first" do
        get :new
        expect(response).to redirect_to(new_ticket_kind_path)
        expect(flash[:error]).to_not be_blank
      end
    end

    describe "create" do
      it "expects to demand that ticket kinds be created first" do
        post :create, batch: {ticket_kind: nil}
        expect(response).to redirect_to(new_ticket_kind_path)
        expect(flash[:error]).to_not be_blank
      end
    end

    describe "index" do
      it "expects to demand that ticket kinds be created first" do
        get :index
        expect(response).to redirect_to(new_ticket_kind_path)
        expect(flash[:error]).to_not be_blank
      end
    end
  end

=begin
def mock_batch(stubs={})
    @mock_batch ||= mock_model(Batch, stubs)
  end

  describe "GET index" do
    it "assigns all batches as @batches" do
      Batch.stub(:find).with(:all).and_return([mock_batch])
      get :index
      expect(assigns[:batches]).to equal [mock_batch]
    end
  end

  describe "GET show" do
    it "assigns the requested batch as @batch" do
      Batch.stub(:find).with("37").and_return(mock_batch)
      get :show, id: "37"
      expect(assigns[:batch]).to equal(mock_batch)
    end
  end

  describe "GET new" do
    it "assigns a new batch as @batch" do
      Batch.stub(:new).and_return(mock_batch)
      get :new
      expect(assigns[:batch]).to equal(mock_batch)
    end
  end

  describe "GET edit" do
    it "assigns the requested batch as @batch" do
      Batch.stub(:find).with("37").and_return(mock_batch)
      get :edit, id: "37"
      expect(assigns[:batch]).to equal(mock_batch)
    end
  end

  describe "POST create" do

    it "expects to create a batch when given valid params" do
      batch = create(:batch)
      expect(Batch).to receive(:new).with(batch.attributes).and_return(batch)
      expect(batch).to receive(:save).and_return(true)

      post :create, batch: batch.attributes

      expect(response).to redirect_to(batch_path batch)
      expect(assigns[:batch]).to be_valid
    end

    it "expects to not create a batch when given invalid params"  do
      attributes = attributes_for :batch, ticket_kind: nil
      post :create, batch: attributes

      expect(response).to be_success
      expect(assigns[:batch]).to be_valid
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested batch" do
        expect(Batch).to receive(:find).with("37").and_return(mock_batch)
        expect(mock_batch).to receive(:update_attributes).with({'these' => 'params'})
        put :update, id: "37", batch: {these: 'params'}
      end

      it "assigns the requested batch as @batch" do
        Batch.stub(:find).and_return(mock_batch(update_attributes: true))
        put :update, id: "1"
        expect(assigns[:batch]).to equal(mock_batch)
      end

      it "redirects to the batch" do
        Batch.stub(:find).and_return(mock_batch(update_attributes: true))
        put :update, id: "1"
        expect(response).to redirect_to(batch_url(mock_batch))
      end
    end

    describe "with invalid params" do
      it "updates the requested batch" do
        expect(Batch).to receive(:find).with("37").and_return(mock_batch)
        expect(mock_batch).to receive(:update_attributes).with({'these' => 'params'})
        put :update, id: "37", batch: {these: 'params'}
      end

      it "assigns the batch as @batch" do
        Batch.stub(:find).and_return(mock_batch(update_attributes: false))
        put :update, id: "1"
        expect(assigns[:batch]).to equal(mock_batch)
      end

      it "re-renders the 'edit' template" do
        Batch.stub(:find).and_return(mock_batch(update_attributes: false))
        put :update, id: "1"
        expect(response).to render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested batch" do
      expect(Batch).to receive(:find).with("37").and_return(mock_batch)
      expect(mock_batch).to receive(:destroy)
      delete :destroy, id: "37"
    end

    it "redirects to the batches list" do
      Batch.stub(:find).and_return(mock_batch(destroy: true))
      delete :destroy, id: "1"
      expect(response).to redirect_to(batches_url)
    end
  end
=end

end
