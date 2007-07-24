#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'

##
# testabtsystemmanager.rb 
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
    @system = AbtSystemManager.new
    @manager = AbtPackageManager.new
    
    # ensure tarball availabe without downloading.
    FileUtils.cp( "#{$PACKAGE_PATH}/ipc-1.4.tar.gz", "#{$SOURCES_REPOSITORY}", :verbose => true ) if !File.exist?( "#{$SOURCES_REPOSITORY}/ipc-1.4.tar.gz" ) 
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtSystemManager.test_cleanup_package_sources()'
  ## 
  def test_cleanup_package_sources
    # remove test package so that sources can be removed.
    if @system.package_installed( "ipc" )
      @manager.remove_package( "ipc" )
    end
    
    # ensure tarball availabe without downloading.
    FileUtils.cp( "#{$PACKAGE_PATH}/ipc-1.4.tar.gz", "#{$SOURCES_REPOSITORY}", :verbose => true ) if !File.exist?( "#{$SOURCES_REPOSITORY}/ipc-1.4.tar.gz" ) 
    
    assert( @system.cleanup_package_sources(), "test_cleanup_package_sources()" )
  end
    
  ##
  # Test method for 'AbtSystemManager.test_verify_installed_files()'
  ## 
  def test_verify_installed_files
    # ensure test package installed.
    if !@system.package_installed( "ipc" )
      @manager.install_package( "ipc" )
    end
    
    assert( @system.verify_installed_files( "ipc" ), "test_verify_installed_files()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.test_verify_symlinks()'
  ## 
  def test_verify_symlinks
    assert( @system.verify_symlinks( "dummy" ), "test_verify_symlinks()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.test_verify_package_depends()'
  ## 
  def test_verify_package_depends
    assert( @system.verify_package_depends( "dummy" ), "test_verify_package_depends()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.test_verify_package_integrity()'
  ## 
  def test_verify_package_integrity
    if !@system.package_installed( "ipc" )
      @manager.install_package( "ipc" )
    end
    
    assert( @system.verify_package_integrity( "ipc" ), "test_verify_package_integrity()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.test_fix_package()'
  ## 
  def test_fix_package
    assert( @system.fix_package( "dummy" ), "test_fix_package()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.test_set_central_repo()'
  ## 
  def test_set_central_repo
    assert( @system.set_central_repo( "http://localhost" ), "test_set_central_repo()" )
  end
  
  ##
  # Test method for 'AbtSystemManager.test_set_package_tree_location()'
  ## 
  def test_set_package_tree_location
    assert( @system.set_package_tree_location( "/var/lib/ericsPackages" ), "test_set_package_tree_location()" )
  end
    
  ##
  # Test method for 'AbtSystemManager.test_package_installed()'
  ## 
  def test_package_installed
    if !@system.package_installed( "ipc" )
      @manager.install_package( "ipc" )
    end
    
    assert( @system.package_installed( "ipc" ), "test_package_installed()" )
  end
  
end
