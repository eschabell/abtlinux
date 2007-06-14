#!/usr/bin/ruby -wI./packages

if ( Process.uid != 0 )
  puts "Enter root password:"
  system( 'su -c ./testSuiteAbt.rb root' )
  exit
end

require 'test/unit'
require 'abtconfig'

require 'TestAbtLogManager'  # test this first ensures all dirs created.
require 'TestAbtDownloadManager'
require 'TestAbtPackage'
require 'TestAbtPackageManager'
require 'TestAbtQueueManager'
require 'TestAbtReportManager'
require 'TestAbtSystemManager'
require 'TestAbtDepEngine'
