#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'AbtSystemManager'

##
# TestAbtSystemManager.rb 
#
# Unit testing for AbtSystemManager class.
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
class TestAbtSystemManager < Test::Unit::TestCase
  
  ##
  # setup method for testing AbtSystemManager.
  ## 
  def setup
    @sys = AbtSystemManager.new()
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtSystemManager.testCleanupPackageSources()'
  ## 
  def testCleanupPackageSources
    assert( @sys.cleanupPackageSources(), "testCleanupPackageSources()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testCleanupLogs()'
  ## 
  def testCleanupLogs
    assert( @sys.cleanupLogs(), "testCleanupLogs()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testVerifyInstalledFiles()'
  ## 
  def testVerifyInstalledFiles
    assert( @sys.verifyInstalledFiles( "dummy" ), "testVerifyInstalledFiles()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testVerifySymlinks()'
  ## 
  def testVerifySymlinks
    assert( @sys.verifySymlinks( "dummy" ), "testVerifySymlinks()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testVerifyPackageDepends()'
  ## 
  def testVerifyPackageDepends
    assert( @sys.verifyPackageDepends( "dummy" ), "testVerifyPackageDepends()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testVerifyPackageIntegrity()'
  ## 
  def testVerifyPackageIntegrity
    assert( @sys.verifyPackageIntegrity( "dummy" ), 
                      "testVerifyPackageIntegrity()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testFixPackage()'
  ## 
  def testFixPackage
    assert( @sys.fixPackage( "dummy" ), "testFixPackage()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testSetCentralRepo()'
  ## 
  def testSetCentralRepo
    assert( @sys.setCentralRepo( "http://localhost" ), "testSetCentralRepo()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.testSetPackageTreeLocation()'
  ## 
  def testSetPackageTreeLocation
    assert( @sys.setPackageTreeLocation( "/var/lib/ericsPackages" ), 
                                      "testSetPackageTreeLocation()" )
  end
  
end
