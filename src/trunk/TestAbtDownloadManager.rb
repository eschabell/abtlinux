#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'
require 'AbtDownloadManager'
require 'AbtLogManager'

##
# TestAbtDownloadManager.rb 
#
# Unit testing for AbtDownloadManager class.
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
class TestAbtDownloadManager < Test::Unit::TestCase
  
  ##
  # setup method for testing AbtDownloadManager.
  ## 
  def setup
    @download = AbtDownloadManager.new()
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtDownloadManager.testRetrievePackageSource()'
  ## 
  def testRetrievePackageSource()
    assert( @download.retrievePackageSource( "ipc", "/tmp" ), 
                                    "testRetrievePackageSource()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.testRetrievePackageTree()'
  ## 
  def testRetrievePackageTree()
    assert( @download.retrievePackageTree( "dummy" ), 
                                      "testRetrievePackageTree()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.testRetrieveNewsFeed()'
  ## 
  def testRetrieveNewsFeed()
    assert( @download.retrieveNewsFeed( $ABTNEWS ), "testRetrieveNewsFeed()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.testUpdatePackage()'
  ## 
  def testUpdatePackage()
    assert( @download.updatePackage(), "testUpdatePackage()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.testUpdatePackageTree()'
  ## 
  def testUpdatePackageTree()
    assert( @download.updatePackageTree(), "testUpdatePackageTree()" )
  end
end
