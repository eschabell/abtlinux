#!/usr/bin/ruby -w

if ( Process.uid != 0 )
  puts "Enter root password:"
  system( 'su -c ./testSuiteAbt.rb root' )
  exit
end

require 'test/unit'
require 'abtconfig'

# By ensuring an install of the test package ipc
# is done prior to running unit tests, we are able
# to ensure that all needed directories, logs, etc 
# are created prior to running the tests. If ipc is
# already installed, this process is not repleated. 
# 
# This speeds up the test suit by more than 10 sec
# on my machine. I get avg runs of around 17,5 sec.
#
logger = AbtLogManager.new
manager = AbtPackageManager.new
manager.installPackage( "ipc" )

require 'testabtpackagemanager'
require 'testabtlogmanager'
require 'testabtdownloadmanager'
require 'testabtpackage'
require 'TestAbtQueueManager'
require 'TestAbtReportManager'
require 'TestAbtSystemManager'
require 'testabtdepengine'
