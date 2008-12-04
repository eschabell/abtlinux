
#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# bzip2.rb 
#
# Bzip2 package.
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

class Bzip2 < AbtPackage
  
protected
  
private
  
  $name         = "Bzip2"
  $version      = "1.0.5"
  $srcDir       = "#{$name.downcase}-#{$version}"
  $srcFile      = "#{$srcDir}.tar.gz"
  $packageData  = {
  	'name'              => $name,
		'execName'          => $name.downcase,
		'version'           => $version,
		'srcDir'            => $srcDir,
    'homepage'          => "http://www.bzip.org",
    'srcUrl'            => "#{$hompage}/#{$version}/#{$srcFile}",
    'dependsOn'         => "",
    'reliesOn'          => "",
    'optionalDO'        => "",
    'optionalRO'        => "",
    'hashCheck'         => "6018889ad37ed76fa79df4b72269f6fcbd1bfaa1",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "GPL",
    'description'       => "bzip2 is a freely available, patent free (see below), high-quality data compressor."
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
