#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# ipc.rb 
#
# Ipc package.
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

class Ipc < AbtPackage
  
protected
  
private
  
  $name				  = "Ipc"
  $version			= "1.4"
  $srcDir			  = "#{$name.downcase}-#{$version}"
  $srcFile      = "#{$srcDir}.tar.gz"
  $packageData	= {
    'name'				      => $name,
    'execName'		      => $name.downcase,
    'version'			      => $version,
    'srcDir'			      => $srcDir,
    'homepage'		      => "http://isotopatcalc.sourceforge.net/",
    'srcUrl'			      => "#{$SOURCEFORGE_URL}/isotopatcalc/#{$srcFile}",
    'dependsOn'			    => "",
    'reliesOn'			    => "",
    'optionalDO'		    => "",
    'optionalRO'		    => "",
    'hashCheck'			    => "e81278607b1d65dcb18c3613ec00fbf588b50319",
    'patches'			      => "",
    'patchesHashCheck'	=> "",
    'mirrorPath'		    => "",
    'license'			      => "GPL",
    'description'		    => "IPC is a program that calculates the isotopic distribution of a given chemical formula."
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
end
