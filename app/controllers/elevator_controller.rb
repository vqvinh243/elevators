class ElevatorController < ApplicationController
  
  include RequestsProcessor, Params, Validator

  cattr_accessor :num_of_elevator, :num_of_floor, :elevators, :elevator, :floors

  @@elevators = Array.new
  @@num_of_elevator = 0

  def init
    render :partial => 'init'
  end

  def index
  	if @@elevators.nil?
  		@@elevators = Array.new
  	end
  end

  def changeNum
    @@num_of_elevator = Integer(numberOfElevator_param)
    @@elevators = Array.new
    @@num_of_elevator.times do
      @@elevators.append Elevator.new
    end
    @@num_of_floor = Integer(numberOfFloor_param)
    @@floors = Array.new
    (@@num_of_floor).times do |floorNum|
      floor = Floor.new(floorNum)
      @@num_of_elevator.times do 
        floor.upList.append SortedSet.new
        floor.downList.append SortedSet.new
      end
      @@floors.append floor
    end
    # this line just only for single elevator case
    @@elevator = @@elevators.first
    # ------------
    redirect_to ""
  end

  def sendRequest
    if validate_request(srcFloor_param, desFloor_param, direction_param, @@num_of_floor)
      @outside_request = OutsideRequest.new(srcFloor_param, direction_param)
      @inside_request = InsideRequest.new(srcFloor_param, desFloor_param, direction_param)
      # Resque.enqueue(ElevatorProcessor, @@elevators, @@elevator, @@floors, @request, srcFloor_param, desFloor_param, direction_param)
      process_requests(@@elevators, @@floors, @outside_request, @inside_request)
    end
    redirect_to ""
  end

  def reload_table
    # simulate movement
    @@elevators.each do |elevator|
      index_of_elevator = elevators.find_index(elevator)
      simulate_elevator_movement(index_of_elevator, elevator, @@floors)
    end
    #----------------#
    render :partial => 'elevators'
  end

  
  
end
