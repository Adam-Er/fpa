# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
use Rack::ContentLength
run Rails.application