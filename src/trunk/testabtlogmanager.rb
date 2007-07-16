#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'

##
# testabtlogmanager.rb 
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
  # Test method for 'AbtLogManager.test_log_package_integrity()'
  ## 
  def test_log_package_integrity()
    assert( @log.log_package_integrity( "ipc" ), "test_log_package_integrity()" )
  end
  
  ## 
  # Test method for 'AbtLogManager.test_log_package_install()'
  ##
  def test_log_package_install()
    assert( @log.log_package_install( "ipc" ), "test_log_package_install()" )
  end
  
  ##
  # Test method for 'AbtLogManager.test_log_package_build()'
  ## 
  def test_log_package_build()
    assert( @log.log_package_build( "ipc" ), "test_log_package_build()" )
  end
  
  ##
  # Test method for 'AbtLogManager.test_cache_package()'
  ## 
  def test_cache_package()
    assert( @log.cache_package( "ipc" ), "test_cache_package()" )
  end
  
  ##
  # Test method for 'AbtLogManager.test_to_journal()'
  ## 
  def test_to_journal()
    assert( @log.to_journal( "Test message from AbtTestSuite." ), "test_to_journal()" )
  end
  
end
