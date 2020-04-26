require_dependency "talking_stick/application_controller"

module TalkingStick
  class RoomsController < ApplicationController
    before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :img_board]
    before_action :set_room, only: [:show, :edit, :update, :signal]
    before_action :set_participant, only: [:signal]

    # GET /rooms
    def index
      @rooms = Room.all if current_user.admin?
      @room = Room.find_by_name(current_user.name)
    end

    # GET /rooms/1
    def show
      if params[:guid]
        if @participant = Participant.where(guid: params[:guid]).first
          @participant.last_seen = Time.now
          @participant.save
        end
      end

      Participant.remove_stale! @room

      response = {
        room: @room,
        participants: @room.participants,
        signals: deliver_signals!
      }

      respond_to do |format|
        format.html
        format.json { render json: response }
        format.js
      end
    end

    # GET /rooms/new
    def new
      @room = Room.new
      @user_options = User.all.map{|u| [ u.name] }
    end

    # GET /rooms/1/edit
    def edit
    end

    # POST /rooms
    def create
      @room = Room.new(room_params)
      if @room.save
        flash[:success] = 'Room was successfully created.'
        redirect_to talking_stick.room_path(@room)
      else
        render :new
      end
    end

    # PATCH/PUT /rooms/1
    def update
      if @room.update(room_params)
        flash[:success] = 'Room was successfully updated.'
        redirect_to talking_stick.room_path(@room)
      else
        render :edit
      end
    end

    # DELETE /rooms/1
    def destroy
      Room.destroy_all
      flash[:success] = 'Room was successfully destroyed.'
      redirect_to talking_stick.rooms_url
    end

    def signal
      signal = signal_params
      signal[:room] = @room
      signal[:sender] = Participant.where(guid: signal[:sender]).first
      signal[:recipient] = @participant
      TalkingStick::Signal.create! signal
      head 204
    end

    def img_board
      if params[:screenshot] and params[:screenshot]['data:image/png;base64,'.length .. -1]
        file = File.open('app/assets/images/board.png', 'wb')
        file.write(Base64.decode64(params[:screenshot]['data:image/png;base64,'.length .. -1]))
        file.close unless file.nil?
      end
    end

    def deliver_signals!
      return [] unless @participant
      data = TalkingStick::Signal.where recipient_id: @participant.id

      # Destroy the signals as we return them, since they have been delivered
      result = []
      data.each do |signal|
        result << {
          signal_type: signal.signal_type,
          sender_guid: signal.sender_guid,
          recipient_guid: signal.recipient_guid,
          data: signal.data,
          room_id: signal.room_id,
          timestamp: signal.created_at,
        }
      end
      data.delete_all
      result
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_room
        @room = Room.find_by(slug: (params[:id] || params[:room_id]))
        redirect_to root_url unless @room
      end

      def set_participant
        @participant = Participant.find(params[:participant_id])
      rescue ActiveRecord::RecordNotFound
        # Retry with ID as GUID
        @participant = Participant.where(guid: params[:participant_id]).first
        raise unless @participant
      end

      # Only allow a trusted parameter "white list" through.
      def room_params
        params.require(:talking_stick_room).permit(:name, :last_used)
      end

      def signal_params
        params.permit(:sender, :signal_type, :data)
      end
  end
end
