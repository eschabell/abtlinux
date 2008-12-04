#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# grep.rb 
#
# Grep package.
#
# Created by Eric D. Schabell <erics@abtlinux.org>
# Copyright 2008, GPL.
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

class Grep < AbtPackage
  
protected
  
private
  
  $name				  = "Grep"
  $version			= "2.5.1"
  $srcDir			  = "#{$name.downcase}-#{$version}"
  $srcFile      = "#{$srcDir}.tar.bz2"
  $packageData	= {
    'name'				      => $name,
    'execName'		      => $name.downcase,
    'version'			      => $version,
    'srcDir'			      => $srcDir,
    'homepage'		      => "http://www.gnu.org/software/grep/",
    'srcUrl'			      => "ftp://ftp.nluug.nl/pub/gnu/grep/#{$srcFile}",
    'dependsOn'			    => "",
    'reliesOn'			    => "",
    'optionalDO'		    => "",
    'optionalRO'		    => "",
    'hashCheck'			    => "82858cc631a7f1ef55597aff661474bef481d4a2",
    'patches'			      => "",
    'patchesHashCheck'	=> "",
    'mirrorPath'		    => "",
    'license'			      => "GPL2",
    'description'		    => "The grep command searches one or more input files for lines containing a match to a specified pattern. By default, grep prints the matching lines."
  }

  
public

  ##
  # Constructor for an AbtPackage, requires all the packge details.
  #
  # <b>PARAM</b> <i>Hash</i> - hash containing all pacakge data.
  #
  ##
  def initialize()
      super($packageData)
  end  
end
