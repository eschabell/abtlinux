#!/usr/bin/ruby -w

$LOAD_PATH.unshift '../'

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'

##
# testabtpackagemanager.rb 
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
    @pkgMgr  = AbtPackageManager.new
    @manager = AbtPackageManager.new
    @system  = AbtSystemManager.new
    
    # ensures download not needed.
    FileUtils.cp "#{$PACKAGE_PATH}/ipc-1.4.tar.gz", "#{$SOURCES_REPOSITORY}", :verbose => true if !File.exist?("#{$SOURCES_REPOSITORY}/ipc-1.4.tar.gz")
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtPackageManager.test_install_package()'
  ## 
  def test_install_package
    if @system.package_installed("ipc")
			
			if @system.package_frozen("ipc")
				@manager.freeze_package("ipc")
			end

      @manager.remove_package("ipc")
    end
    
    assert(@pkgMgr.install_package("ipc", $verbose), "test_install_package()")
  end
  
  ##
  # Test method for 'AbtPackageManager.test_reinstall_package()'
  ## 
  def test_reinstall_package
    if !@system.package_installed("ipc")
      @manager.install_package("ipc")
    end
    
		if @system.package_frozen("ipc")
			@manager.freeze_package("ipc")
		end

    assert(@pkgMgr.reinstall_package("ipc", true), "test_reinstall_package()")
  end
  
  ##
  # Test method for 'AbtPackageManager.test_remove_package()'
  ## 
  def test_remove_package
    if !@system.package_installed("ipc")
      @manager.install_package("ipc")
    end
      
		if @system.package_frozen("ipc")
			@manager.freeze_package("ipc")
		end

    assert(@pkgMgr.remove_package("ipc"), "test_remove_package()")
  end
  
  ##
  # Test method for 'AbtPackageManager.test_downgrade_package()'
  ## 
  def test_downgrade_package
    if !@system.package_installed("ipc")
      @manager.install_package("ipc")
    end

		if @system.package_frozen("ipc")
			@manager.freeze_package("ipc")
		end
    
    assert(@pkgMgr.downgrade_package("ipc", "1.2"), "test_downgrade_package()")
  end
  
  ##
  # Test method for 'AbtPackageManager.test_freeze_package()'
  ## 
  def test_freeze_package
    if !@system.package_installed("ipc")
      @manager.install_package("ipc")
    end
    
		if !@system.package_frozen("ipc")
    	assert(@pkgMgr.freeze_package("ipc"), "test_freeze_package()")

			# need to return package to initial state, un-frozen.
			@pkgMgr.freeze_package("ipc")
		else
			assert(true)
		end
  end
  
end
