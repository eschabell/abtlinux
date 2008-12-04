
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# texinfo.rb 
#
# Texinfo package.
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

class Texinfo < AbtPackage
  
protected
  
private
  
  $name         = "Texinfo"
  $version      = "4.11"
  $srcDir       = "#{$name.downcase}-#{$version}"
  $srcFile      = "#{$srcDir}.tar.bz2"
  $packageData  = {
    'name'              => $name,
    'execName'          => $name.downcase,
    'version'           => $version,
    'srcDir'            => $srcDir,
    'homepage'          => "http://www.gnu.org/software/#{$name.downcase}",
    'srcUrl'            => "#{$GNU_URL}/#{$name.downcase}/#{$srcFile}",
    'dependsOn'         => "",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "b4028a9e4801873ef7739d81295fa917eb460825",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "Texinfo is the official documentation format of the GNU project."
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
