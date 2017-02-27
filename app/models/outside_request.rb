class OutsideRequest < Request
	attr_accessor :floor

	def initialize(floor, direction)
		@floor = floor
		@direction = direction
	end
end
