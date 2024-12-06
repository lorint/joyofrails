# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Module.class_exec &::Brick::ADD_CONST_MISSING
Rails.application.initialize!
