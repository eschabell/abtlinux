#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'

##
# testabtdownloadmanager.rb 
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
  # Test method for 'AbtDownloadManager.test_retrieve_package_source()'
  ## 
  def test_retrieve_package_source()
    assert( 
      @download.retrieve_package_source( "ipc", "#{$SOURCES_REPOSITORY}" ), "test_retrieve_package_source()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.test_retrieve_package_tree()'
  ## 
  def test_retrieve_package_tree()
    assert( @download.retrieve_package_tree( "dummy" ), "test_retrieve_package_tree()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.test_retrieve_news_feed()'
  ## 
  def test_retrieve_news_feed()
    assert( @download.retrieve_news_feed( $ABTNEWS ), "test_retrieve_news_feed()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.test_update_package()'
  ## 
  def test_update_package()
    assert( @download.update_package() , "test_update_package()" )
  end
  
  ##
  # Test method for 'AbtDownloadManager.test_update_package_tree()'
  ## 
  def test_update_package_tree()
    assert( @download.update_package_tree(), "test_update_package_tree()" )
  end

  ##
  # Test method for 'AbtDownloadManager.test_validated()'
  ##
  def test_validated()
    assert( @download.validated( 'e81278607b1d65dcb18c3613ec00fbf588b50319', "#{$SOURCES_REPOSITORY}/ipc-1.4.tar.gz" ), "test_validated" )
  end
end
