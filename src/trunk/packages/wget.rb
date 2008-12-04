
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# wget.rb 
#
# Wget package.
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

class Wget < AbtPackage
  
protected
  
private
  
  $name         = "Wget"
  $version      = "1.11"
  $srcDir       = "wget-1.11"
  $srcFile      = "wget-1.11.tar.bz2"
  $packageData  = {
    'name'              => "wget",
    'execName'          => "wget",
    'version'           => "1.11",
    'srcDir'            => "wget-1.11",
    'homepage'          => "http://www.gnu.org/software/wget",
    'srcUrl'            => "#{$GNU_URL}/wget/wget-1.11.tar.bz2",
    'dependsOn'         => "",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "93c1dca3d6a6a0ef697b9e284ae6c67ab9c853e5",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "GNU Wget is a free software package for retrieving files using HTTP, HTTPS and FTP, the most widely-used Internet protocols."
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
