
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# sed.rb 
#
# Sed package.
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

class Sed < AbtPackage
  
protected
  
private
  
  $name         = "Sed"
  $version      = "4.1.5"
  $srcDir       = "sed-4.1.5"
  $srcFile      = "sed-4.1.5.tar.gz"
  $packageData  = {
    'name'              => "sed",
    'execName'          => "sed",
    'version'           => "4.1.5",
    'srcDir'            => "sed-4.1.5",
    'homepage'          => "http://www.gnu.org/software/sed/",
    'srcUrl'            => "#{$GNU_URL}/sed/sed-4.1.5.tar.gz",
    'dependsOn'         => "patch, gnupg, readline, autoconf",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "db6e18e4f42ec32c1b6d39b48839c6d11390d30c",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL2",
    'description'       => "Sed (streams editor) is used to filter text."
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
