class Event
	attr_accessor :curFloor, :action

	def initialize()
		@curFloor = 0
		@action = Action::UP
	end
end