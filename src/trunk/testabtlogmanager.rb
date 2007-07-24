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
    @logger = AbtLogManager.new
    @manager = AbtPackageManager.new
    @system  = AbtSystemManager.new
    
    # ensures download not needed.
    FileUtils.cp "#{$PACKAGE_PATH}/ipc-1.4.tar.gz", "#{$SOURCES_REPOSITORY}", :verbose => true if !File.exist?( "#{$SOURCES_REPOSITORY}/ipc-1.4.tar.gz" )
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
    FileUtils.rm( "#{$ABT_TMP}/ipc-1.4.watch" ) if File.exist?( "#{$ABT_TMP}/ipc-1.2.watch" )
  end
  
  ##
  # Test method for 'AbtLogManager.test_log_package_integrity()'
  ## 
  def test_log_package_integrity()
    if !@system.package_installed( "ipc" )
      @manager.install_package( "ipc" )
    end
    
    assert( @logger.log_package_integrity( "ipc" ), "test_log_package_integrity()" )
  end
  
  ## 
  # Test method for 'AbtLogManager.test_log_package_install()'
  ##
  def test_log_package_install()
    if !@system.package_installed( "ipc" )
      @manager.install_package( "ipc" )
    end

    # fill installwatch file.
    File.open( "#{$ABT_TMP}/ipc-1.4.watch", "w" ) do |file|
      file.puts "5       open    /usr/local/bin/ipc      #success"
      file.puts "0       chmod   /usr/local/bin/ipc      00600   #success"
      file.puts "0       chown   /usr/local/bin/ipc      -1      -1      #success"
      file.puts "0       chmod   /usr/local/bin/ipc      00755   #success"
      file.puts "5       open    /usr/local/share/ipc/elemente   #success"
      file.puts "0       chmod   /usr/local/share/ipc/elemente   00600   #success"
      file.puts "0       chown   /usr/local/share/ipc/elemente   -1      -1      #success"
      file.puts "0       chmod   /usr/local/share/ipc/elemente   00644   #success"
    end
    
    assert( @logger.log_package_install( "ipc" ), "test_log_package_install()" )
  end
  
  ##
  # Test method for 'AbtLogManager.test_log_package_build()'
  ## 
  def test_log_package_build()
    if !@system.package_installed( "ipc" )
      @manager.install_package( "ipc" )
    end
  
    assert( @logger.log_package_build( "ipc" ), "test_log_package_build()" )
  end
  
  ##
  # Test method for 'AbtLogManager.test_cache_package()'
  ## 
  def test_cache_package()
    if !@system.package_installed( "ipc" )
      @manager.install_package( "ipc" )
    end
    
    assert( @logger.cache_package( "ipc" ), "test_cache_package()" )
  end
  
  ##
  # Test method for 'AbtLogManager.test_to_journal()'
  ## 
  def test_to_journal()
    assert( @logger.to_journal( "Test message from AbtTestSuite." ), "test_to_journal()" )
  end
end
