module RequestsProcessor

	# FOR SINGLE ELEVATOR ----------------- BEGIN

  def process_requests(elevators, floors, outside_request, inside_request)
    # for single elevator
    elevator = find_elevator_for_outside_request(elevators, outside_request)

    elevator_index = elevators.find_index(elevator)

    # -------------------------#
    append_requests(elevator_index, elevator, outside_request, inside_request, floors)
  end

  def append_requests(elevator_index, elevator, outside_request, inside_request, floors)
    append_outside_request(elevator, outside_request)
    append_inside_request(elevator_index, floors, inside_request)
  end

    def append_outside_request(elevator, request)
      if request.direction == Action::UP
        elevator.upList.add request.floor
      elsif request.direction == Action::DOWN
        elevator.downList.add request.floor
      end
      update_behavior(elevator, request)
    end

    def append_inside_request(elevator_index, floors, inside_request)
      floor = floors.fetch(inside_request.srcFloor)
      if inside_request.direction == Action::UP and inside_request.desFloor > inside_request.srcFloor
        floor.upList.at(elevator_index).add inside_request.desFloor
      elsif inside_request.direction == Action::DOWN and inside_request.desFloor < inside_request.srcFloor
        floor.downList.at(elevator_index).add inside_request.desFloor
      end
    end

  

    def update_behavior(elevator, request)
      if elevator.upList.empty? and elevator.downList.empty?
        elevator.state = State::IDLE
      else
        if request.direction == Action::UP and elevator.event.action != Action::DOWN
          if elevator.event.curFloor > elevator.upList.max
            elevator.event.action = Action::DOWN
          else
            elevator.event.action = Action::UP
          end
        elsif request.direction == Action::DOWN and elevator.event.action != Action::UP
          if elevator.event.curFloor < elevator.downList.min
            elevator.event.action = Action::UP
          else
            elevator.event.action = Action::DOWN
          end
        end
        elevator.state = State::ONMOVE
      end
      ######TODO######
    end 

  def get_inside_request(index_of_elevator, elevator, floors)
      floor = floors.fetch(elevator.event.curFloor, nil)
      unless floor.nil?
        if elevator.event.action == Action::UP
          elevator.upList.merge(floor.upList.at(index_of_elevator))
          floor.upList.at(index_of_elevator).clear
        elsif elevator.event.action == Action::DOWN
          elevator.downList.merge(floor.downList.at(index_of_elevator))
          floor.downList.at(index_of_elevator).clear
        end
      end
    end

    def simulate_elevator_movement(index_of_elevator, elevator, floors)
      get_inside_request(index_of_elevator, elevator, floors)
      # IN CASE MOVING UP
      if elevator.event.action == Action::UP and elevator.upList.size > 0

        # clear destination floor in the list when reach to it
        if elevator.upList.include? elevator.event.curFloor
          elevator.state = State::WAITING
          elevator.upList.delete_if{ |floor| floor == elevator.event.curFloor }

        # in-case there no higher floor request, need to reverse direction
        elsif elevator.upList.max < elevator.event.curFloor
          elevator.event.curFloor = elevator.event.curFloor - 1
          elevator.event.action = Action::DOWN
          elevator.state = State::ONMOVE

        # no special case, continue moving
        else
          elevator.event.curFloor = elevator.event.curFloor + 1
          elevator.state = State::ONMOVE
        end

      # IN CASE MOVING DOWN
      elsif elevator.event.action == Action::DOWN and elevator.downList.size > 0

         # clear destination floor in the list when reach to it
        if elevator.downList.include? elevator.event.curFloor
          elevator.state = State::WAITING
          elevator.downList.delete_if { |floor| floor == elevator.event.curFloor }
          
        # in-case there no lower floor request, need to reverse direction
        elsif elevator.downList.min > elevator.event.curFloor
          elevator.event.curFloor = elevator.event.curFloor + 1
          elevator.event.action = Action::UP
          elevator.state = State::ONMOVE

        # no special case, continue moving
        else
          elevator.event.curFloor = elevator.event.curFloor - 1
          elevator.state = State::ONMOVE
        end

      # IN CASE MOVING DOWN TO CATCH GO-UP REQUEST
      elsif elevator.event.action == Action::DOWN and elevator.upList.size > 0
        if elevator.upList.min > elevator.event.curFloor
          elevator.event.action = Action::UP
        elsif elevator.upList.min == elevator.event.curFloor
          elevator.state = State::WAITING
          elevator.event.action = Action::UP
          elevator.upList.delete_if{ |floor| floor == elevator.event.curFloor }
        else
          elevator.event.curFloor = elevator.event.curFloor - 1
        end

      # IN CASE MOVING UP TO CATCH GO-DOWN REQUEST
      elsif elevator.event.action == Action::UP and elevator.downList.size > 0
        if elevator.downList.max < elevator.event.curFloor
          elevator.event.action = Action::DOWN
        elsif elevator.downList.max == elevator.event.curFloor
          elevator.state = State::WAITING
          elevator.event.action = Action::DOWN
          elevator.downList.delete_if{ |floor| floor == elevator.event.curFloor }
        else
          elevator.event.curFloor = elevator.event.curFloor + 1
        end
      elsif elevator.upList.empty? and elevator.downList.empty?
        elevator.state = State::IDLE
      end  

    end


# FOR SINGLE ELEVATOR ---------------- END

# FOR MULTIPLE ELEVATORS -------------- BEGIN
  def find_elevator_for_outside_request(elevators, request)
    # GET ELEVATOR ON THE WAY TO REQUESTED FLOOR --------------- BEGIN
    elevator = (elevators.select { |e| check_outsiderequest_and_elevator_direction(e, request)}).first
    # GET ELEVATOR ON THE WAY TO REQUESTED FLOOR --------------- END
    if elevator.nil?
    # GET NEAREST IDLE ELEVATOR ------------------ BEGIN
      idle_elevators = (elevators.select { |e| e.state == State::IDLE })
      if idle_elevators.size > 0
        elevator = idle_elevators.first
        idle_elevators.each do |e|
          if (elevator.event.curFloor-request.floor).abs > (e.event.curFloor-request.floor).abs
            elevator = e
          end
        end
    # GET NEAREST IDLE ELEVATOR ------------------ END
      else
    # GET ELEVATOR HAS NEAREST FINISHED FLOOR --------------- BEGIN
        elevator = elevators.first
        elevators.each do |e|
          distance = get_smallest_distance(elevator, request)
          distance_to_check = get_smallest_distance(e, request)
          if distance > distance_to_check
            elevator = e
          end
        end
    # GET ELEVATOR HAS NEAREST FINISHED FLOOR --------------- END
      end
    end
    return elevator
  end

  private
  def check_outsiderequest_and_elevator_direction(elevator, request)
    if elevator.state == State::ONMOVE or elevator.state == State::WAITING
      if elevator.event.action == Action::UP and elevator.event.curFloor <= request.floor and elevator.upList.size > 0
        return true
      elsif elevator.event.action == Action::DOWN and elevator.event.curFloor >= request.floor and elevator.downList.size > 0
        return true
      end
    end
    return false
  end

  def get_smallest_distance(elevator, request)
    if elevator.downList.size > 0
      distance_down = (request.floor - elevator.downList.min).abs
    else
      return (request.floor - elevator.upList.max).abs
    end

    if elevator.upList.size > 0
      distance_up = (request.floor - elevator.upList.max).abs
    end

    if distance_down > distance_up
      return distance_up
    else
      return distance_down
    end
  end

 # FOR MULTIPLE ELEVATORS -------------- END
end