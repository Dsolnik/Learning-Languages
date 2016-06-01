require 'spec_helper'
require 'zombie'
describe Zombie do 
	zombie = Zombie.new
	zombie.name.should == 'Ash'
end