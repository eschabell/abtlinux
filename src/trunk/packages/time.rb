#!/usr/bin/ruby -w

require "AbtPackage"

##
# time.rb 
#
# AbtFortune package.
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

class Time < AbtPackage
  
protected
  
private
  
  $name					= "Time"
  $version			= "1.7"
  $srcDir				= "#{$name.downcase}-#{$version}"
  $packageData	= {
    'name'							=> $name,
    'execName'					=> $name.downcase,
    'version'						=> $version,
    'srcDir'						=> $srcDir,
    'homepage'					=> "ftp://www.gnu.org/directory/GNU/time.html",
    'srcUrl'						=> "ftp://ftp.nluug.nl/pub/gnu/#{$name.downcase}/#{$srcdir}",
    'dependsOn'					=> "",
    'reliesOn'					=> "",
    'optionalDO'				=> "",
    'optionalRO'				=> "",
    'hashCheck'					=> "sha512:d759b651e343beddc0b3bd06af85881486b72319c979a2e7f752d5a34edd8b7c1c19391c5c7a2e8f6685746cc7a046bf2c8e082b31458a1dd043ed90a4cebcd1",
    'patches'						=> "",
    'patchesHashCheck'	=> "",
    'mirrorPath'				=> "",
    'license'						=> "GPL",
    'description'				=> "The 'time' command runs another program, then displays information about the resources used by that program, collected by the system while the program was running. You can select which information is reported and the format in which it is shown, or have 'time' save the information in a file instead of displaying it on the screen."
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
