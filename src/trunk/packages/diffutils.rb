
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# diffutils.rb 
#
# Diffutils package.
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

class Diffutils < AbtPackage
  
protected
  
private
  
  $name         = "Diffutils"
  $version      = "2.8.1"
  $srcDir       = "diffutils-2.8.1"
  $srcFile      = "diffutils-2.8.1.tar.gz"
  $packageData  = {
    'name'              => "diffutils",
    'execName'          => "diff",
    'version'           => "2.8.1",
    'srcDir'            => "diffutils-2.8.1",
    'homepage'          => "http://www.gnu.org/software/diffutils/diffutils.html",
    'srcUrl'            => "#{$GNU_URL}/diffutils/diffutils-2.8.1.tar.gz",
    'dependsOn'         => "",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "5cbbd79a1036a7cd0c821dc84b98dc2e38ab7c55",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "Computer users often find occasion to ask how two files differ. Perhaps one file is a newer version of the other file. Or maybe the two files started out as identical copies but were changed by different people."
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
