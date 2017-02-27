class InsideRequest < Request
	attr_accessor :srcFloor, :desFloor

	def initialize(srcFloor, desFloor, direction)
		@srcFloor = srcFloor
		@desFloor = desFloor
		@direction = direction
	end
end