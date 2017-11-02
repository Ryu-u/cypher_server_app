# This file is used by Rack-based servers to start the application.
require 'sprockets'
require 'coffee-script'
#require 'therubyracer'
require 'sass'
require_relative 'config/environment'

run Rails.application
