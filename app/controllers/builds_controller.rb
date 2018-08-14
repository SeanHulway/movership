class BuildsController < ApplicationController
  layout "funnel_layout"
  before_action :find_build, only: [:show, :edit, :update, :destroy]
  before_action :item_type, :room_type

  def index
    @builds = Build.all.order("created_at DESC")
    if !current_user.try(:admin?)
      redirect_to new_build_path
    end
  end

  def show
    sec = (calculate_total_cube(@build)*6/1000.00 * 3600).to_i
    min, sec = sec.divmod(60)
    hour, min = min.divmod(60)

    if(min < 35 && 5 < min)
      min = 30
    elsif(min >= 35)
      min = 0
      hour = hour + 1
    else
      min = 0
    end

    if(hour < 1)
      hour = 1
      min = 0
    end

    cost = (hour * 105)
    if(min = 30)
      cost = (cost + 53)
    end

    @build_weight = (calculate_total_cube(@build)*6).to_s + 'lbs'
    @build_cost = "$" + cost.to_s
    @build_time = "%2d:%02d" % [hour, min]
  end

  def new
    @build = Build.new
  end

  def create
    @build = Build.new(build_params)

    if @build.save
      redirect_to @build, notice: "Your estimate has been sent!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @build.update(build_params)
      redirect_to @build
    else
      render 'edit'
    end
  end

  def destroy
    @build.destroy
    redirect_to builds_path, notice: "Successfully deleted the build"
  end

  private

  def item_type
    @item_type = ['Item', 'Bed', 'Dresser', 'Couch', 'Table', 'Chair', 'Armoire', 'Book Shelf', 'China Cabinet', 'Entertainment Center', 'Box', 'Fridge', 'Other']
  end

  def room_type
    @room_type = ['Room', 'Bedroom', 'Basement', 'Dining Room', 'Family Room', 'Garage', 'Kitchen', 'Living Room', 'Other']
  end

  def calculate_total_cube(build)
    total = 0;
    build.rooms.each do |room|
      room.items.each do |item|
        total = total + (item_to_cube(item.name.to_s) * item.quantity)
      end
    end
    total
  end

  def item_to_cube(item)
    item_map = {
      'Bed' => 65,
      'Dresser' => 40,
      'Couch' => 50,
      'Table' => 10,
      'Chair' => 5,
      'Armoire' => 40,
      'Book Shelf' => 40,
      'China Cabinet' => 30,
      'Entertainment Center' => 35,
      'Fridge' => 35,
      'Box' => 1.5,
      'Other' => 25
    }

    item_map[item]
  end

  def build_params
    params.require(:build).permit(
      :name,
      :phone,
      :email, 
      :primary_contact, 
      :start_type, 
      :start_address, 
      :start_city, 
      :start_state, 
      :start_zip, 
      :destination_type, 
      :destination_address, 
      :destination_city, 
      :destination_state, 
      :destination_zip,
      :moving_date,
      :description,
      rooms_attributes: [:id, :name, :_destroy,
        items_attributes: [:id, :name, :description, :quantity, :_destroy]],
        items_attributes: [:id, :description, :_destroy])
  end

  def find_build
    @build = Build.find(params[:id])
  end
end
