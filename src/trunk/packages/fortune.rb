#!/usr/bin/ruby -w

require "abtpackage"

##
# fortune.rb 
#
# Fortune package.
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

class Fortune < AbtPackage
  
protected
  
private
  
  $name				= "Fortune"
  $version			= "mod-9708"
  $srcDir			= "#{$name.downcase}-#{$version}"
  $packageData	    = {
    'name'						=> $name,
    'execName'					=> $name.downcase,
    'version'					=> $version,
    'srcDir'					=> $srcDir,
    'homepage'					=> "http://www.ibiblio.org/pub/Linux/games/amusements/#{$name.downcase}/",
    'srcUrl'					=> "http://www.ibiblio.org/pub/Linux/games/amusements/#{$name.downcase}/#{$srcDir}.tar.gz",
    'dependsOn'					=> "",
    'reliesOn'					=> "",
    'optionalDO'				=> "",
    'optionalRO'				=> "",
    'hashCheck'					=> "sha512:80c5b71d84eeb3092b2dfe483f0dad8ed42e2efeaa1f8791c2",
    'patches'					=> "http://patches.abtlinux.org/#{$srcDir}-patches-1.tar.gz",
    'patchesHashCheck'          => "",
    'mirrorPath'				=> "http://mirror.abtlinux.org/#{$srcDir}.tar.gz",
    'license'					=> "GPL",
    'description'				=> "Prints a random, hopefully interesting, adage." 
  }

  
public

  ##
  # Constructor for an AbtPackage, requires all the packge details.
  #
  # <b>PARAM</b> <i>Hash</i> - hash containing all pacakge data.
  #
  ##
  def initialize()
      super( $packageData )
  end

	##
	# Overriding configure.
	#
	# <b>RETURN</b> <i>boolean</i> - returns true.
	##
	def configure 
		return true  # nothing to do, standard makefile is fine.
	end
end
