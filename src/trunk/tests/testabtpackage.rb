#!/usr/bin/ruby -w

$LOAD_PATH.unshift '../'
$LOAD_PATH.unshift '../packages/'

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'abtconfig'
require 'ipc'

##
# testabtpackage.rb 
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
  $verbose      = false
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
    @ipc     = Ipc.new
    
    # ensures download not needed.
    FileUtils.cp "#{$PACKAGE_PATH}/ipc-1.4.tar.gz", "#{$SOURCES_REPOSITORY}", :verbose => true if !File.exist? "#{$SOURCES_REPOSITORY}/ipc-1.4.tar.gz"
  end
  
  ##
  # teardown method to cleanup after testing.
  ##
  def teardown
    FileUtils.rm_r "#{$BUILD_LOCATION}/#{$dataTest['srcDir']}", :verbose => true if File.exist? "#{$BUILD_LOCATION}/#{$dataTest['srcDir']}"
  end
  
  ##
  # Test method for 'AbtPackage.test_details()'
  ## 
  def test_details
    assert_equal( $dataTest['name'], @ipc.details['Package name'], "test_details(name)" )
    assert_equal( $dataTest['execName'], @ipc.details['Executable'], "test_details(execName)" )
    assert_equal( $dataTest['version'], @ipc.details['Version'], "test_details(version)" )
    assert_equal( $dataTest['srcDir'], @ipc.details['Source location'], "test_details(srcDir)" )
    assert_equal( $dataTest['homepage'], @ipc.details['Homepage'], "test_details(homepage)" )
  end
  
  ##
  # Test method for 'AbtPackage.test_pre()'
  ## 
  def test_pre
    assert( @ipc.pre( $verbose ), "test_pre()" )
  end
  
  ##
  # Test method for 'AbtPackage.test_configure()'
  ##
  def test_configure
    if ( !@ipc.pre( $verbose ) ) 
      assert_equals( true, false, "test_configure(pre)" )
    end
    assert( @ipc.configure( $verbose ), "test_configure(configure)" )
  end
  
  ##
  # Test method for 'AbtPackage.test_build()'
  ##
  def test_build
    if ( !@ipc.pre( $verbose ) ) 
      assert_equals( true, false, "test_build(pre)" )
    end
    if ( !@ipc.configure( $verbose ) ) 
      assert_equals( true, false, "test_build(configure)" )
    end
    assert( @ipc.build( $verbose ), "test_build(build)" )
  end
  
  ##
  # Test method for 'AbtPackage.test_preinstall()'
  ##
  def test_preinstall
    assert( @ipc.preinstall( $verbose ), "test_preinstall()" )
  end
  
  ##
  # Test method for 'AbtPackage.test_install()'
  ##
  def test_install
  
    if ( !@ipc.pre( $verbose ) ) 
      assert_equals( true, false, "test_install(pre)" )
    end
    if ( !@ipc.configure( $verbose ) ) 
      assert_equals( true, false, "test_install(configure)" )
    end
    if ( !@ipc.build( $verbose ) ) 
      assert_equals( true, false, "test_install(build)" )
    end
    if ( !@ipc.preinstall( $verbose ) ) 
      assert_equals( true, false, "test_install(install)" )
    end
    assert( @ipc.install( $verbose ), "test_install(install)" )
  end
  
  ##
  # Test method for 'AbtPackage.test_post()'
  ##
  def test_post
    assert_equals( true, false, "test_post(pre)" ) if ( !@ipc.pre( $verbose ) ) 
    assert_equals( true, false, "test_post(configure)" ) if ( !@ipc.configure( $verbose ) ) 
    assert_equals( true, false, "test_post(build)" ) if ( !@ipc.build( $verbose ) ) 
    assert_equals( true, false, "test_post(preinstall)" ) if ( !@ipc.preinstall( $verbose ) ) 
    assert_equals( true, false, "test_post(install)" ) if ( !@ipc.install( $verbose ) ) 
    assert( @ipc.post( $verbose ), "test_post(post)" )
  end
  
end
