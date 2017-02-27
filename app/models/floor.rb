class Floor
	attr_accessor :number, :requestList, :upList, :downList

	def initialize(number)
		@number = number
		@upList = Array.new
		@downList = Array.new
	end
end