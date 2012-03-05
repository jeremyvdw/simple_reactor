#!/usr/bin/env ruby

require 'rubygems' # or use Bundler.setup
require 'simple_reactor'

# initialize the reactor
reactor = SimpleReactor::Base.new

# start the main loop
reactor.run do
  
  puts "Hello world"
  
  # stops the reactor
  reactor.stop
end