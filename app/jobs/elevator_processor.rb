# class ElevatorProcessor

# 	@queue = :elevator_processor

# 	def self.perform(elevators, elevator, floors, request, srcFloor, desFloor, direction)
# 		append_requests(elevator, request, floors, srcFloor, desFloor, direction)
# 		elevators.each do |elevator|
# 			simulate_elevator_movement(floors, elevator)
# 		end
# 	end

# 	def append_requests(elevator, request, floors, srcFloor, desFloor, direction)
#     	append_outside_request(elevator, request)
#     	append_inside_request(floors, srcFloor, desFloor, direction)
#   	end

#   	def append_outside_request(elevator, request)
# 	    if request.direction == Action::UP
# 	      elevator.upList.add request.floor
# 	    elsif request.direction == Action::DOWN
# 	      elevator.downList.add request.floor
# 	    end
# 	    update_behavior(elevator, request)
#   	end

#   	def append_inside_request(floors, srcFloor, desFloor, direction)
# 	    floor = floors.fetch(srcFloor)
# 	    if direction == Action::UP and desFloor > srcFloor
# 	      floor.upList.add desFloor
# 	    elsif direction == Action::DOWN and desFloor < srcFloor
# 	      floor.downList.add desFloor
# 	    end
#   	end

  

#   	def update_behavior(elevator, request)
# 	    if elevator.upList.empty? and elevator.downList.empty?
# 	      elevator.state = State::IDLE
# 	    else
# 	      if request.direction == Action::UP and elevator.event.action != Action::DOWN
# 	        if elevator.event.curFloor > elevator.upList.max
# 	          elevator.event.action = Action::DOWN
# 	        else
# 	          elevator.event.action = Action::UP
# 	        end
# 	      elsif request.direction == Action::DOWN and elevator.event.action != Action::UP
# 	        if elevator.event.curFloor < elevator.downList.min
# 	          elevator.event.action = Action::UP
# 	        else
# 	          elevator.event.action = Action::DOWN
# 	        end
# 	      end
# 	      elevator.state = State::ONMOVE
# 	    end
#     	######TODO######
#   	end 

# 	def get_inside_request(floors, elevator)
# 	    floor = floors.fetch(elevator.event.curFloor, nil)
# 	    unless floor.nil?
# 	      if elevator.event.action == Action::UP
# 	        elevator.upList.merge(floor.upList)
# 	        floor.upList.clear
# 	      elsif elevator.event.action == Action::DOWN
# 	        elevator.downList.merge(floor.downList)
# 	        floor.downList.clear
# 	      end
# 	    end
#   	end

#   	def simulate_elevator_movement(floors, elevator)
# 	    get_inside_request(floors, elevator)
# 	    # IN CASE MOVING UP
# 	    if elevator.event.action == Action::UP and elevator.upList.size > 0

# 	      # clear destination floor in the list when reach to it
# 	      if elevator.upList.include? elevator.event.curFloor
# 	        elevator.state = State::WAITING
# 	        elevator.upList.delete_if{ |floor| floor == elevator.event.curFloor }

# 	      # in-case there no higher floor request, need to reverse direction
# 	      elsif elevator.upList.max < elevator.event.curFloor
# 	        elevator.event.curFloor = elevator.event.curFloor - 1
# 	        elevator.event.action = Action::DOWN
# 	        elevator.state = State::ONMOVE

# 	      # no special case, continue moving
# 	      else
# 	        elevator.event.curFloor = elevator.event.curFloor + 1
# 	        elevator.state = State::ONMOVE
# 	      end

# 	    # IN CASE MOVING DOWN
# 	    elsif elevator.event.action == Action::DOWN and elevator.downList.size > 0

# 	       # clear destination floor in the list when reach to it
# 	      if elevator.downList.include? elevator.event.curFloor
# 	        elevator.state = State::WAITING
# 	        elevator.downList.delete_if { |floor| floor == elevator.event.curFloor }
	        
# 	      # in-case there no lower floor request, need to reverse direction
# 	      elsif elevator.downList.min > elevator.event.curFloor
# 	        elevator.event.curFloor = elevator.event.curFloor + 1
# 	        elevator.event.action = Action::UP
# 	        elevator.state = State::ONMOVE

# 	      # no special case, continue moving
# 	      else
# 	        elevator.event.curFloor = elevator.event.curFloor - 1
# 	        elevator.state = State::ONMOVE
# 	      end

# 	    # IN CASE MOVING DOWN TO CATCH GO-UP REQUEST
# 	    elsif elevator.event.action == Action::DOWN and elevator.upList.size > 0
# 	      if elevator.upList.min > elevator.event.curFloor
# 	        elevator.event.action = Action::UP
# 	      elsif elevator.upList.min == elevator.event.curFloor
# 	        elevator.state = State::WAITING
# 	        elevator.event.action = Action::UP
# 	        elevator.upList.delete_if{ |floor| floor == elevator.event.curFloor }
# 	      else
# 	        elevator.event.curFloor = elevator.event.curFloor - 1
# 	      end

# 	    # IN CASE MOVING UP TO CATCH GO-DOWN REQUEST
# 	    elsif elevator.event.action == Action::UP and elevator.downList.size > 0
# 	      if elevator.downList.max < elevator.event.curFloor
# 	        elevator.event.action = Action::DOWN
# 	      elsif elevator.downList.max == elevator.event.curFloor
# 	        elevator.state = State::WAITING
# 	        elevator.event.action = Action::DOWN
# 	        elevator.downList.delete_if{ |floor| floor == elevator.event.curFloor }
# 	      else
# 	        elevator.event.curFloor = elevator.event.curFloor + 1
# 	      end
# 	    elsif elevator.upList.empty? and elevator.downList.empty?
# 	    	elevator.state = State::IDLE
# 	    end  

#   	end
# end