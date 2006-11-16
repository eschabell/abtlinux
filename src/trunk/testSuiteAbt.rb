#!/usr/bin/ruby -wI./packages

if ( Process.uid != 0 )
	puts "Enter root password:"
	system( 'su -c ./testSuiteAbt.rb root' )
	exit
end

require 'test/unit'
require 'abtConfig'
require 'TestAbtDepEngine'
require 'TestAbtDownloadManager'
require 'TestAbtLogManager'
require 'TestAbtPackage'
require 'TestAbtPackageManager'
require 'TestAbtQueueManager'
require 'TestAbtReportManager'
require 'TestAbtSystemManager'
