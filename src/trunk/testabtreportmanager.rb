#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'

##
# testabtreportmanager.rb 
#
# Unit testing for AbtReportManager class.
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
class TestAbtReportManager < Test::Unit::TestCase
  
  ##
  # setup method for testing AbtReportManager.
  ## 
  def setup
    @report = AbtReportManager.new()
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_package_details()'
  ## 
  def test_show_package_details
    assert( @report.show_package_details( "ipc" ), "test_show_package_details()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_installed_packages()'
  ## 
  def test_show_installed_packages
    assert( @report.show_installed_packages(), "test_show_installed_packages()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_package_log()'
  ## 
  def test_show_package_log
    assert( @report.show_package_log( "ipc", "install" ), "test_show_package_log(install)" )
    assert( @report.show_package_log( "ipc", "build" ), "test_show_package_log(build)" )
    assert( @report.show_package_log( "ipc", "integrity" ), "test_show_package_log(integrity)" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_frozen_packages()'
  ## 
  def test_show_frozen_packages
    assert( @report.show_frozen_packages(), "test_show_frozen_packages()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_package_dependencies()'
  ## 
  def test_show_package_dependencies
    assert( false, "test_show_package_dependencies()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_untracked_files()'
  ## 
  def test_show_untracked_files
    assert( @report.show_untracked_files(), "test_show_untracked_files()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_journal()'
  ## 
  def test_show_journal
    assert( @report.show_journal( $JOURNAL ), "test_show_journal()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_file_owner()'
  ## 
  def test_show_file_owner
    assert( @report.show_file_owner( "ipcFile" ), "test_show_file_owner()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_search_package_descriptions()'
  ## 
  def test_search_package_descriptions
    assert( @report.search_package_descriptions( "Special text" ), "test_search_package_descriptions()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_queue()'
  ## 
  def test_show_queue
    if ( @report.show_queue( "install" ) )
      assert(false, "test_show_queue()")
    else
      assert(true, "test_show_queue()")
    end
  end
  
  ##
  # Test method for 'AbtReportManager.test_show_updates()'
  ## 
  def test_show_updates
    assert( @report.show_updates( "ipc" ), "test_show_updates()" )
  end
  
  ##
  # Test method for 'AbtReportManager.test_generate_HTML_package_listing()'
  ## 
  def test_generate_HTML_package_listing
    assert( @report.generate_HTML_package_listing(), "test_generate_HTML_package_listing()" )
  end
  
end
