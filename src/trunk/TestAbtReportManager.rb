#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'AbtReportManager'

##
# TestAbtReportManager.rb 
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
  # Test method for 'AbtReportManager.testShowPackageDetails()'
  ## 
  def testShowPackageDetails
    assert( @report.showPackageDetails( "fortune" ), "testShowPackageDetails()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowInstalledPackages()'
  ## 
  def testShowInstalledPackages
    assert( @report.showInstalledPackages(), "testShowInstalledPackages()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowPackageLog()'
  ## 
  def testShowPackageLog
    assert( @report.showPackageLog( "fortune", "install" ), "testShowPackageLog()" )
    assert( @report.showPackageLog( "fortune", "build" ), "testShowPackageLog()" )
    assert( @report.showPackageLog( "fortune", "integrity" ), "testShowPackageLog()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowFrozenPackages()'
  ## 
  def testShowFrozenPackages
    assert( @report.showFrozenPackages(), "testShowFrozenPackages()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowPackageDependencies()'
  ## 
  def testShowPackageDependencies
    #assert( @report.showPackageDependencies( "fortune" ), "testShowPackageDependencies()" )
    assert( false, "testShowPackageDependencies()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowUntrackedFiles()'
  ## 
  def testShowUntrackedFiles
    assert( @report.showUntrackedFiles(), "testShowUntrackedFiles()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowJournal()'
  ## 
  def testShowJournal
    assert( @report.showJournal( $JOURNAL ), "testShowJournal()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowFileOwner()'
  ## 
  def testShowFileOwner
    assert( @report.showFileOwner( "fortuneFile" ), "testShowFileOwner()" )
  end

  ##
  # Test method for 'AbtReportManager.testSearchPackageDescriptions()'
  ## 
  def testSearchPackageDescriptions
    assert( @report.searchPackageDescriptions( "Special text" ), "testSearchPackageDescriptions()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowQueue()'
  ## 
  def testShowQueue
    assert( @report.showQueue( "install" ), "testShowQueue()" )
  end

  ##
  # Test method for 'AbtReportManager.testShowUpdates()'
  ## 
  def testShowUpdates
    assert( @report.showUpdates( "fortune" ), "testShowUpdates()" )
  end

  ##
  # Test method for 'AbtReportManager.testGenerateHTMLPackageListing()'
  ## 
  def testGenerateHTMLPackageListing
    assert( @report.generateHTMLPackageListing(), "testGenerateHTMLPackageListing()" )
  end

end
