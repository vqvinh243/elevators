module Params

	def numberOfElevator_param
	  	params.require(:numOfElevator).to_i
	end

	 def numberOfFloor_param
	    params.require(:numOfFloor).to_i
	end

	def srcFloor_param
	    params.require(:srcFloor).to_i
	end

	def desFloor_param
		params.require(:desFloor).to_i
	end

	def direction_param
	    params.require(:direction)
	end

end