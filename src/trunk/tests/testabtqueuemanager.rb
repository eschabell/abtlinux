#!/usr/bin/ruby -w

$LOAD_PATH.unshift '../'

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'

##
# testabtqueuemanager.rb 
#
# Unit testing for AbtQueueManager class.
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
class TestAbtQueueManager < Test::Unit::TestCase
  
  ##
  # setup method for testing AbtQueueManager.
  ## 
  def setup
    @queue = AbtQueueManager.new
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtQueueManager.action_package_queue()'
  ## 
  def test_action_package_queue
    assert( @queue.action_package_queue( "ipc", "install", "add" ), "test_action_package_queue(add)" )
    assert( @queue.action_package_queue( "ipc", "install" ), "test_action_package_queue(default add again)" )
    assert( @queue.action_package_queue( "ipc", "install", "remove" ), "test_action_package_queue(remove)" )
    
  end
  
end
