#!/usr/bin/ruby -w

if (Process.uid != 0)
  puts "Enter root password:"
  system('su -c ./testsuiteabt.rb root')
  exit
end

$LOAD_PATH.unshift '../'

require 'test/unit'

# if a new setup, you need to run 'abt -h' to ensure things are installed
# correctly (self tests will sort it out for you).
#
#if !system('../abt.rb -h')
#	puts "\nYou need to run 'abt -h' before this testsuite will run, (self tests will sort out the missing components for you)."
#  exit
#end

# if a new setup, test build of our default test package to ensure system can
# build.
#
#system('../abt.rb remove ipc')
#if !system('../abt.rb install ipc')
#	puts "\nProblem building the system, see journal for details."
#	exit
#end


# now we run the testsuite.
require 'testabtpackagemanager'
require 'testabtlogmanager'
require 'testabtdownloadmanager'
require 'testabtpackage'
require 'testabtqueuemanager'
require 'testabtreportmanager'
require 'testabtsystemmanager'
require 'testabtdepengine'
