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
      redirect_to @build, notice: "Your information has been sent. Thank you for taking the time and filling out the form. This estimate is only an approximation. Someone will be in contact with you to go over this information and finalize the estimate."
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
    @item_type = ['Item','Air Condition, Window','Armoire','BBQ Grill','Baby Carriage','Bar, Portable','Basket, Small','Bassinet','Bed','Bed, Bunk (Set of 2)','Bed, Double / Full','Bed, King','Bed, Queen','Bed, Rollaway','Bed, Single / Twin','Bed, Youth','Bench, Harvest','Bench, Piano','Bench, Picnic','Bench, Vanity','Bicycle','Bird Bath','Book Shelf','Box, Small / Book','Box, Medium','Box, Large / Dish','Box, X-Large','Box, Grand / Wardrobe','Box, Mirror','Buffet, Base','Buffet, Hutch','Cabinet','Cabinet, China','Cabinet, Corner','Cabinet, Curio/Gun','Cabinet, Utitlity','Camp Stove, Portable','Canoe / Kayak / Scull','Car Ramps','Cart, Serving','Cedar Chest','Chair','Chair, Arm or Straight','Chair, Boudoir','Chair, Child','Chair, Dining','Chair, Folding','Chair, High','Chair, Kitchen','Chair, Lawn','Chair, Occasional','Chair, Overstuffed','Chair, Rocker','Chair, Swivel / Office','Chaise Lounge','Chaise Lounge','Changing Table','Chest, Toy','China Cabinet','Clock, Grandfather','Clothes Hamper / Basket','Computer PC/Monitor','Cooler, Larger','Cooler, Small','Copier / Printer, Medium','Copier / Printer, Small','Couch','Crib','Day Bed','Dehumidifier','Desk, Computer','Desk, Hutch','Desk, Office','Desk, Secretary','Desk, Small / Winthrop','Desk, Small','Dishwasher','Dog House / Cage','Dresser','Dresser, Child','Dresser, Double','Dresser, Single','Dresser, Triple','Dresser, Vanity','Dryer, Ele or Gas','Entertainment Center','Exercise Bike/Cycle','Fan, Portable','Fax Machine','File Cabinet, 2 Drawer','File Cabinet, 3 Drawer','File Cabinet, 4 Drawer','File Cabinet, Lateral','Fireplace, Equip 5 PC','Fishing Rods','Foot Locker','Foot Stool','Freezer, 10CF or less','Freezer, 11 to 15 CF','Freezer, 16 CF & Over','Fridge','Garbage Can, Outdoor','Garden Tools (5)','Glider / Settee','Golf Bag','Golf Cart','Gun Cabinet / Locker','Heater, Gas or Electric','Hibachi / Small BBQ','Hose Caddy','Hot Tub / Jacuzzi / Spa','Humidifer','Ironing Board','Ladder, 6 Ft Step','Ladder, 8 Ft Metal','Ladder, Extension','Lamp, Floor or Pole','Lawn Mower, Hand','Lawn Mower, Power','Lawn Mower, Riding','Leaf Sweeper/ Weeder','Microwave','Motorcycle','Outdoor Gym','Outdoor Slide','Outdoor Swingset','Piano, Baby Grand/Upright','Piano, Grand','Piano, Spinet','Ping Pong Table','Plant, Faux; Plant Stand','Playpen','Pool Table, Not Slate','Pool Table, Slate','Power Tools(3)','Rocker, Swing','Rub, Small Roll or Pad','Rug, Large Roll or Pad','Sandbox','Sewing Machine, Port','Shed, Tool or Utility','Shelf, Metal / Plastic','Skis','Sled','Snow Mobile','Snowblower','Sofa, 2 Cushion','Sofa, 3 Cushion','Sofa, 4 Cushion','Sofa, Hideabed','Sofa, Sectional, per Sec','Spreader','Step Stool / Cart','Stereo Component','Stero Stand / Table','Stroller, Baby','Suitcase / Tote Box','Table','Table, Breakfast','Table, Cad','Table, Child','Table, Dining','Table, Dropleaf/Coffee','Table, End / Nest','Table, End','Table, Night','Table, Patio','Table, Picnic','Table, Small','Table, Umbrella','Tackle Box','Television, Big Screen','Television, Console','Television, Portable','Television, Table Model','Tent','Tool Chest, Large','Tool Chest, Medium','Tool Chest, Small','Treadmill / Step Mach','Tricycle','Typewriter','Universal Gym Comp','VCR/DVD','Vacuum / Rug Cleaner','Wagon, Child','Wall Table','Wardrobe/Armoir, Large','Wardrobe/Armoire, Small','Washing Machine','Waterbed Frame / Ped','Weight Bench','Wheelbarrow / Dolly','Work Bench / Cabinet','Other',]
  end

  def room_type
    @room_type = ['Room', 'Bathroom', 'Bedroom', 'Basement', 'Dining Room', 'Family Room', 'Garage', 'Kitchen', 'Laundry Room', 'Living Room', 'Mud Room', 'Office', 'OutSide', 'Sun Room', 'Other']
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
      'Air Condition, Window' => 20,
      'Armoire' => 40,
      'BBQ Grill' => 5,
      'Baby Carriage' => 10,
      'Bar, Portable' => 15,
      'Basket, Small' => 3,
      'Bassinet' => 5,
      'Bed' => 65,
      'Bed, Bunk (Set of 2)' => 70,
      'Bed, Double / Full' => 60,
      'Bed, King' => 70,
      'Bed, Queen' => 65,
      'Bed, Rollaway' => 20,
      'Bed, Single / Twin' => 40,
      'Bed, Youth' => 30,
      'Bench, Harvest' => 10,
      'Bench, Piano' => 5,
      'Bench, Picnic' => 5,
      'Bench, Vanity' => 3,
      'Bicycle' => 7,
      'Bird Bath' => 15,
      'Book Shelf' => 40,
      'Box, Small / Book' => 1,
      'Box, Medium' => 3,
      'Box, Large / Dish' => 6,
      'Box, X-Large' => 6,
      'Box, Grand / Wardrobe' => 16,
      'Box, Mirror' => 3,
      'Buffet, Base' => 20,
      'Buffet, Hutch' => 30,
      'Cabinet' => 30,
      'Cabinet, China' => 25,
      'Cabinet, Corner' => 20,
      'Cabinet, Curio/Gun' => 10,
      'Cabinet, Utitlity' => 10,
      'Camp Stove, Portable' => 8,
      'Canoe / Kayak / Scull' => 50,
      'Car Ramps' => 6,
      'Cart, Serving' => 15,
      'Cedar Chest' => 15,
      'Chair' => 5,
      'Chair, Arm or Straight' => 5,
      'Chair, Boudoir' => 10,
      'Chair, Child' => 3,
      'Chair, Dining' => 5,
      'Chair, Folding' => 1,
      'Chair, High' => 5,
      'Chair, Kitchen' => 5,
      'Chair, Lawn' => 5,
      'Chair, Occasional' => 15,
      'Chair, Overstuffed' => 25,
      'Chair, Rocker' => 12,
      'Chair, Swivel / Office' => 8,
      'Chaise Lounge' => 22,
      'Chaise Lounge' => 25,
      'Changing Table' => 10,
      'Chest, Toy' => 5,
      'China Cabinet' => 30,
      'Clock, Grandfather' => 20,
      'Clothes Hamper / Basket' => 5,
      'Computer PC/Monitor' => 15,
      'Cooler, Larger' => 5,
      'Cooler, Small' => 3,
      'Copier / Printer, Medium' => 12,
      'Copier / Printer, Small' => 8,
      'Couch' => 50,
      'Crib' => 10,
      'Day Bed' => 30,
      'Dehumidifier' => 10,
      'Desk, Computer' => 25,
      'Desk, Hutch' => 28,
      'Desk, Office' => 30,
      'Desk, Secretary' => 35,
      'Desk, Small / Winthrop' => 22,
      'Desk, Small' => 22,
      'Dishwasher' => 20,
      'Dog House / Cage' => 10,
      'Dresser' => 40,
      'Dresser, Child' => 12,
      'Dresser, Double' => 40,
      'Dresser, Single' => 30,
      'Dresser, Triple' => 50,
      'Dresser, Vanity' => 20,
      'Dryer, Ele or Gas' => 25,
      'Entertainment Center' => 35,
      'Exercise Bike/Cycle' => 10,
      'Fan, Portable' => 5,
      'Fax Machine' => 2,
      'File Cabinet, 2 Drawer' =>5,
      'File Cabinet, 3 Drawer' =>8,
      'File Cabinet, 4 Drawer' =>10,
      'File Cabinet, Lateral' =>15,
      'Fireplace, Equip 5 PC' => 5,
      'Fishing Rods' => 1,
      'Foot Locker' => 5,
      'Foot Stool' => 2,
      'Freezer, 10CF or less' => 30,
      'Freezer, 11 to 15 CF' => 45,
      'Freezer, 16 CF & Over' => 60,
      'Fridge' => 35,
      'Garbage Can, Outdoor' => 7,
      'Garden Tools (5)' => 10,
      'Glider / Settee' => 20,
      'Golf Bag' => 2,
      'Golf Cart' => 40,
      'Gun Cabinet / Locker' => 30,
      'Heater, Gas or Electric' => 5,
      'Hibachi / Small BBQ' => 3,
      'Hose Caddy' => 5,
      'Hot Tub / Jacuzzi / Spa' => 300,
      'Humidifer' => 5,
      'Ironing Board' => 2,
      'Ladder, 6 Ft Step' => 5,
      'Ladder, 8 Ft Metal' => 8,
      'Ladder, Extension' => 10,
      'Lamp, Floor or Pole' => 3,
      'Lawn Mower, Hand' => 5,
      'Lawn Mower, Power' => 15,
      'Lawn Mower, Riding' => 55,
      'Leaf Sweeper/ Weeder' => 5,
      'Microwave' => 8,
      'Motorcycle' => 60,
      'Outdoor Gym' => 20,
      'Outdoor Slide' => 10,
      'Outdoor Swingset' => 25,
      'Piano, Baby Grand/Upright' => 70,
      'Piano, Grand' => 80,
      'Piano, Spinet' => 60,
      'Ping Pong Table' => 20,
      'Plant, Faux; Plant Stand' => 3,
      'Playpen' => 2,
      'Pool Table, Not Slate' => 40,
      'Pool Table, Slate' => 100,
      'Power Tools(3)' => 15,
      'Rocker, Swing' => 15,
      'Rub, Small Roll or Pad' => 3,
      'Rug, Large Roll or Pad' => 10,
      'Sandbox' => 10,
      'Sewing Machine, Port' => 5,
      'Shed, Tool or Utility' => 120,
      'Shelf, Metal / Plastic' => 5,
      'Skis' => 2,
      'Sled' => 2,
      'Snow Mobile' => 60,
      'Snowblower' => 10,
      'Sofa, 2 Cushion' => 35,
      'Sofa, 3 Cushion' => 50,
      'Sofa, 4 Cushion' => 60,
      'Sofa, Hideabed' => 50,
      'Sofa, Sectional, per Sec' => 30,
      'Spreader' => 4,
      'Step Stool / Cart' => 3,
      'Stereo Component' => 3,
      'Stero Stand / Table' => 10,
      'Stroller, Baby' => 8,
      'Suitcase / Tote Box' => 5,
      'Table' => 10,
      'Table, Breakfast' => 10,
      'Table, Cad' => 1,
      'Table, Child' => 5,
      'Table, Dining' => 30,
      'Table, Dropleaf/Coffee' => 12,
      'Table, End / Nest' => 5,
      'Table, End' => 5,
      'Table, Night' => 5,
      'Table, Patio' => 10,
      'Table, Picnic' => 20,
      'Table, Small' => 5,
      'Table, Umbrella' => 5,
      'Tackle Box' => 1,
      'Television, Big Screen' => 20,
      'Television, Console' => 20,
      'Television, Portable' => 5,
      'Television, Table Model' => 10,
      'Tent' => 5,
      'Tool Chest, Large' => 15,
      'Tool Chest, Medium' => 10,
      'Tool Chest, Small' => 5,
      'Treadmill / Step Mach' => 20,
      'Tricycle' => 5,
      'Typewriter' => 5,
      'Universal Gym Comp' => 10,
      'VCR/DVD' => 3,
      'Vacuum / Rug Cleaner' => 5,
      'Wagon, Child' => 3,
      'Wall Table' => 5,
      'Wardrobe/Armoir, Large' => 40,
      'Wardrobe/Armoire, Small' => 20,
      'Washing Machine' => 25,
      'Waterbed Frame / Ped' => 15,
      'Weight Bench' => 5,
      'Wheelbarrow / Dolly' => 8,
      'Work Bench / Cabinet' => 20,
      'Other' => 25,
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
