#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
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
  # Test method for 'AbtLogManager.testLogPackageIntegrity()'
  ## 
  def testLogPackageIntegrity()
    #assert( @log.logPackageIntegrity( "dummy" ), "testLogPackageIntegrity()" )
    assert( false, "testLogPackageIntegrity()" )
  end
  
  ##
  # Test method for 'AbtLogManager.testLogPackageInstall()'
  ## 
  def testLogPackageInstall()
    assert( @log.logPackageInstall( "dummy" ), "testLogPackageInstall()" )
  end

  ##
  # Test method for 'AbtLogManager.testLogPackageBuild()'
  ## 
  def testLogPackageBuild()
    assert( @log.logPackageBuild( "dummy" ), "testLogPackageBuild()" )
  end

  ##
  # Test method for 'AbtLogManager.testCachePackage()'
  ## 
  def testCachePackage()
    assert( @log.cachePackage( "dummy" ), "testCachePackage()" )
  end

  ##
  # Test method for 'AbtLogManager.testLogToJournal()'
  ## 
  def testLogToJournal()
    assert( @log.logToJournal( "Test message." ), "testLogToJournal()" )
  end

end
