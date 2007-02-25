#!/usr/bin/ruby -w

require 'test/unit/testcase'
require 'test/unit/autorunner'
require 'AbtPackage'

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

  $name     = "Fortune"
  $version  = "mod-9708"
  $srcDir   = "#{$name.downcase}-#{$version}"

  $data = {
    'name'              => "Fortune",
    'execName'          => $name.downcase,
    'version'           => $version,
    'srcDir'            => $srcDir,
    'homepage'          => "http://www.ibiblio.org/pub/Linux/games/amusements/#{$name.downcase}/",
    'srcUrl'            => "http://www.ibiblio.org/pub/Linux/games/amusements/#{$srcDir}.tar.gz",
    'dependsOn'         => "none",
    'reliesOn'          => "none",
    'optionalDO'        => "none",
    'optionalRO'        => "none",
    'hashCheck'         => "sha512:80c5b71d84eeb3092b2dfe483f0dad8ed42e2ef",
    'patches'           => "http://patches.abtlinux.org/#{$srcDir}-patches-1.tar.gz",
    'patchesHashCheck'  => "sha512:80c5b71d84eeb3092b2dfe483f0dad8ed42",
    'mirrorPath'        => "http://mirror.abtlinux.org/#{$srcDir}.tar.gz",
    'license'           => "GPL",
    'description'       => "Prints a random, hopefully interesting, adage." 
  }

  ##
  # setup method for testing AbtPackage.
  ## 
  def setup
    @fortune = AbtPackage.new( $data )
  end

  ##
  # Test method for 'AbtPackage.testDetails()'
  ## 
  def testDetails
    assert_equal( $data['name'], @fortune.details['Package name'], "testDetails()" )
    assert_equal( $data['execName'], @fortune.details['Executable'], "testDetails()" )
    assert_equal( $data['version'], @fortune.details['Version'], "testDetails()" )
    assert_equal( $data['srcDir'], @fortune.details['Source location'], "testDetails()" )
    assert_equal( $data['homepage'], @fortune.details['Homepage'], "testDetails()" )
    assert_equal( $data['srcUrl'], @fortune.details['Source uri'], "testDetails()" )
    assert_equal( $data['dependsOn'], @fortune.details['Depends On'], "testDetails()" )
    assert_equal( $data['reliesOn'], @fortune.details['Relies On'], "testDetails()" )
    assert_equal( $data['optionalDO'], @fortune.details['Optional DO'], "testDetails()" )
    assert_equal( $data['optionalRO'], @fortune.details['Optional RO'], "testDetails()" )
    assert_equal( $data['hashCheck'], @fortune.details['Security hash'], "testDetails()" )
    assert_equal( $data['patches'], @fortune.details['Patches'], "testDetails()" )
    assert_equal( $data['patchesHashCheck'], @fortune.details['Patches hash'], "testDetails()" )
    assert_equal( $data['mirrorPath'], @fortune.details['Mirror'], "testDetails()" )
    assert_equal( $data['license'], @fortune.details['License'], "testDetails()" )
    assert_equal( $data['description'], @fortune.details['Description'], "testDetails()" )
  end
  
  ##
  # Test method for 'AbtPackage.testPre()'
  ## 
  def testPre
    assert( @fortune.pre(), "testPre()" )
  end

  ##
  # Test method for 'AbtPackage.testConfigure()'
  ##
  def testConfigure
    assert_equal( true, true, "testConfigure()" )
  end

  ##
  # Test method for 'AbtPackage.testBuild()'
  ##
  def testBuild
    assert_equal( false, true, "testBuild()" )
  end

  ##
  # Test method for 'AbtPackage.testPreinstall()'
  ##
  def testPreinstall
    assert_equal( false, true, "testPreinstall()" )
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
    assert_equal( false, true, "testPost()" )
  end

end
