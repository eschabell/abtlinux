
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# gawk.rb 
#
# Gawk package.
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

class Gawk < AbtPackage
  
protected
  
private
  
  $name         = "Gawk"
  $version      = "3.1.6"
  $srcDir       = "#{$name.downcase}-#{$version}"
  $srcFile      = "#{$name.downcase}-#{$version}.tar.bz2"
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
    'hashCheck'         => "3eb3b7d6e835e4d653fad1bfa2165b1cf06625d6",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "The awk utility interprets a special-purpose programming language that makes it possible to handle simple data-reformatting jobs with just a few line"
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
