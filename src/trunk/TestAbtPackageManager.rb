#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'

##
# TestAbtPackageManager.rb 
#
# Unit testing for AbtPackageManager class.
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
class TestAbtPackageManager < Test::Unit::TestCase

  $verbose = false;  # quiets testing output.
  
  ##
  # setup method for testing AbtPackageManager.
  ## 
  def setup
    @pkgMgr = AbtPackageManager.new()
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtPackageManager.testInstallPackage()'
  ## 
  def testInstallPackage
    assert( @pkgMgr.installPackage( "ipc", $verbose ), "testInstallPackage()" )
  end
  
  ##
  # Test method for 'AbtPackageManager.testReinstallPackage()'
  ## 
  def testReinstallPackage
    assert( @pkgMgr.reinstallPackage( "ipc" ), "testReinstallPackage()" )
  end
  
  ##
  # Test method for 'AbtPackageManager.testRemovePackage()'
  ## 
  def testRemovePackage
    assert( @pkgMgr.removePackage( "ipc" ), "testRemovePackage()" )
  end
  
  ##
  # Test method for 'AbtPackageManager.testDowngradePackage()'
  ## 
  def testDowngradePackage
    assert( @pkgMgr.downgradePackage( "ipc", "1.2" ), "testDowngradePackage()" )
  end
  
  ##
  # Test method for 'AbtPackageManager.testFreezePackage()'
  ## 
  def testFreezePackage
    assert( @pkgMgr.freezePackage( "ipc" ), "testFreezePackage()" )
  end
  
end
