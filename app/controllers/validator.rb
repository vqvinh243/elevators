module Validator

	def validate_request(srcFloor, desFloor, direction, numOfFloors)
		if validate_existed_floors(numOfFloors, srcFloor, desFloor) and validate_direction(direction, srcFloor, desFloor)
			return true
		else 
			return false
		end
	end

	private
	def validate_existed_floors(numOfFloors, srcFloor, desFloor)
		if srcFloor >= 0 and desFloor >= 0 and srcFloor < numOfFloors and desFloor < numOfFloors
			return true
		else
			return false
		end
	end

	def validate_direction(direction, srcFloor, desFloor)
		if (srcFloor < desFloor and direction == Action::UP) or (srcFloor > desFloor and direction == Action::DOWN)
			return true
		else
			return false
		end
	end
end