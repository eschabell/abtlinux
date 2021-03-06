
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# tar.rb 
#
# Tar package.
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

class Tar < AbtPackage
  
protected
  
private
  
  $name         = "Tar"
  $version      = "1.20"
  $srcDir       = "tar-1.20"
  $srcFile      = "tar-1.20.tar.bz2"
  $packageData  = {
    'name'              => "tar",
    'execName'          => "tar",
    'version'           => "1.20",
    'srcDir'            => "tar-1.20",
    'homepage'          => "http://www.gnu.org/software/tar",
    'srcUrl'            => "#{$GNU_URL}/tar/tar-1.20.tar.bz2",
    'dependsOn'         => "",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "33f484716af8f36bf44c342d28b2916bd89dc67c",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "The Tar program provides the ability to create tar archives."
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
