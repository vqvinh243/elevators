class Elevator
	attr_accessor :downList, :upList, :curFloor, :event, :state, :position
	def initialize()
		@upList = SortedSet.new
		@downList = SortedSet.new
		@event = Event.new
		@state = State::IDLE
	end
end
