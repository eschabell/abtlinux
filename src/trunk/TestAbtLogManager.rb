#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'
require 'AbtLogManager'

##
# TestAbtLogManager.rb 
#
# Unit testing for AbtLogManager class.
#
# Created by Eric D. Schabell <erics@abtlinux.org>
# Copyright 2006, GPL.
#
# This file is part of AbTLinux.
#
# AbTLinux is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# AbTLinux is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#																    
# You should have received a copy of the GNU General Public License along with
# AbTLinux; if not, write to the Free Software Foundation, Inc., 51 Franklin
# St, Fifth Floor, Boston, MA 02110-1301  USA
##
class TestAbtLogManager < Test::Unit::TestCase
  
  ##
  # setup method for testing AbtLogManager.
  ## 
  def setup
    @log = AbtLogManager.new()
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtLogManager.testLogPackageIntegrity()'
  ## 
  def testLogPackageIntegrity()
    #assert( @log.logPackageIntegrity( "ipc" ), "testLogPackageIntegrity()" )
    assert( false, "testLogPackageIntegrity()" )
  end
  
  ## 
  # Test method for 'AbtLogManager.testLogPackageInstall()'
  ##
  # TODO: sort out a setup for this test. 
  #def testLogPackageInstall()
  #  assert( @log.logPackageInstall( "ipc" ), "testLogPackageInstall()" )
  #end
  
  ##
  # Test method for 'AbtLogManager.testLogPackageBuild()'
  ## 
  def testLogPackageBuild()
    assert( @log.logPackageBuild( "ipc" ), "testLogPackageBuild()" )
  end
  
  ##
  # Test method for 'AbtLogManager.testCachePackage()'
  ## 
  def testCachePackage()
    assert( @log.cachePackage( "ipc" ), "testCachePackage()" )
  end
  
  ##
  # Test method for 'AbtLogManager.testLogToJournal()'
  ## 
  def testLogToJournal()
    assert( @log.logToJournal( "Test message from AbtTestSuite." ), 
                                                  "testLogToJournal()" )
  end
  
end
