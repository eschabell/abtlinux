#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'
require 'AbtPackage'
require 'AbtDownloadManager'
require 'packages/ipc'

##
# TestAbtPackage.rb 
#
# Unit testing for AbtPackage class.
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
class TestAbtPackage < Test::Unit::TestCase

  $nameTest     = "Ipc"
  $versionTest  = "1.4"
  $srcDirTest   = "#{$nameTest.downcase}-#{$versionTest}"

  $dataTest = {
    'name'              => $nameTest,
    'execName'          => $nameTest.downcase,
    'version'           => $versionTest,
    'srcDir'            => $srcDirTest,
    'homepage'          => "http://isotopatcalc.sourceforge.net/"
  }

  ##
  # setup method for testing AbtPackage.
  ## 
  def setup
    @ipc = Ipc.new
  end

  ##
  # Test method for 'AbtPackage.testDetails()'
  ## 
  def testDetails
    assert_equal( $dataTest['name'], @ipc.details['Package name'], "testDetails()" )
    assert_equal( $dataTest['execName'], @ipc.details['Executable'], "testDetails()" )
    assert_equal( $dataTest['version'], @ipc.details['Version'], "testDetails()" )
    assert_equal( $dataTest['srcDir'], @ipc.details['Source location'], "testDetails()" )
    assert_equal( $dataTest['homepage'], @ipc.details['Homepage'], "testDetails()" )
  end
  
  ##
  # Test method for 'AbtPackage.testPre()'
  ## 
  def testPre
    assert( @ipc.pre(), "testPre()" )
  end

  ##
  # Test method for 'AbtPackage.testConfigure()'
  ##
  def testConfigure
    if ( !@ipc.pre() ) 
      assert_equals( true, false, "testConfigure()" )
    end
    assert( @ipc.configure(), "testConfigure()" )
  end

  ##
  # Test method for 'AbtPackage.testBuild()'
  ##
  def testBuild
    if ( !@ipc.pre() ) 
      assert_equals( true, false, "testConfigure()" )
    end
    if ( !@ipc.configure() ) 
      assert_equals( true, false, "testConfigure()" )
    end
    assert( @ipc.build(), "testBuild()" )
  end

  ##
  # Test method for 'AbtPackage.testPreinstall()'
  ##
  def testPreinstall
    assert( @ipc.preinstall(), "testPreinstall()" )
  end

  ##
  # Test method for 'AbtPackage.testInstall()'
  ##
  def testInstall
    assert_equal( false, true, "testInstall()" )
  end

  ##
  # Test method for 'AbtPackage.testPost()'
  ##
  def testPost
    assert( @ipc.post(), "testPost()" )
  end

end
