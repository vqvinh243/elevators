# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
# require 'resque/tasks'
require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# unless ENV['RESQUE_WORKER'] == 'true'
#   require File.expand_path('../config/application', __FILE__)
#   Elevators::Application.load_tasks 
# else
#   ROOT_PATH = File.expand_path("..", __FILE__)
#   load File.join(ROOT_PATH, 'lib/tasks/resque.rake')
# end