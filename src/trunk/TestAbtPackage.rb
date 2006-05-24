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


class TestAbtPacakge < Test::Unit::TestCase

  @name     = "Fortune"
  @version  = "mod-9708"
  @srcDir   = "#{@name.downcase}-#{@version}"

  $data = {
    'name'           	=> "Fortune",
    'execName'		  	=> @name.downcase,
    'version'			=> @version,
    'srcDir'			=> @srcDir,
    'homepage'  		=> "http://www.ibiblio.org/pub/Linux/games/amusements/#{@name.downcase}/",
    'srcUrl'		  	=> "http://www.ibiblio.org/pub/Linux/games/amusements/#{@srcDir}.tar.gz",
    'dependsOn'		  	=> "",
    'reliesOn'			=> "",
    'optionalDO'		=> "",
    'optionalRO'		=> "",
    'hashCheck'		  	=> "sha512:80c5b71d84eeb3092b2dfe483f0dad8ed42e2efeaa1f8791c26fb2ae80fbd7775777ac5252b1d8270e2e176ad14ce98940bee6d8e71fdbb9ac3323dc7188c4d0",
    'patches'		  	=> "http://patches.abtlinux.org/#{@srcDir}-patches-1.tar.gz",
    'patcheshashCheck'  => "",
    'mirrorPath'		=> "http://mirror.abtlinux.org/#{@srcDir}.tar.gz",
    'license'		  	=> "GPL",
    'description'	  	=> "Prints a random, hopefully interesting, adage." 
  }

  def setup
    @fortune = AbtPackage.new( $data )
  end

  def testDetails
    assert( $data['name'] == @fortune.details['name'] )
  end

end
