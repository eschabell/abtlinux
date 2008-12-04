
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# binutils.rb 
#
# Binutils package.
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

class Binutils < AbtPackage
  
protected
  
private
  
  $name         = "Binutils"
  $version      = "2.18"
  $srcDir       = "binutils-2.18"
  $srcFile      = "binutils-2.18.tar.gz"
  $packageData  = {
    'name'              => "binutils",
    'execName'          => "binutils",
    'version'           => "2.18",
    'srcDir'            => "binutils-2.18",
    'homepage'          => "http://www.gnu.org/software/binutils",
    'srcUrl'            => "#{$GNU_URL}/binutils/binutils-2.18.tar.gz",
    'dependsOn'         => "",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "51db5e3c62a19172b0e0be9372ddce450479c8b1",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "The GNU Binutils are a collection of binary tools."
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
