class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_filter :retreive_elevators

  # def retreive_elevators
  # 	@elevators = Rails.cache.fetch("elevators") do |variable|
  # 		Elevator.all.collect(&:elevator)
  # 	end
  # end
end
