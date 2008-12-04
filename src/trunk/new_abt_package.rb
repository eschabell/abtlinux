#!/usr/bin/ruby -w

##
# new_abt_package.rb
#
# Creates a new abt package using a simple standard template and user queries.
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

$DEFAULT_PREFIX = "/usr/local"
libpath = "#{$DEFAULT_PREFIX}/var/lib/abt"
$LOAD_PATH.unshift libpath
load 'abtconfig.rb'
  
# get name of package.
puts "What is the packages name?"
$packageName = gets.chomp

# get version.
puts "What is the version number of this package?"
$version = gets.chomp

# get source file name.
puts "Source file is gz or bz2?"
$compression = gets.chomp.downcase
$srcFile = "\#{$srcDir}.tar.#{$compression}"

# get website / homepage.
puts "What is the packages website url?"
$website = gets.chomp

# get source url.
puts "What is the source download location url?"
$srcUrl = gets.chomp

# get dependsOn.
puts "Definition dependsOn: If package foo1 depends on package foo2, then package 
foo1 will be rebuilt any time package foo2 is rebuilt."
puts "Does this package depend on another? Provide a comma seperated list."
$dependsOn = gets.chomp

# get reliesOn.
puts "Definition reliesOn: If package foo1 relies on package foo2, then package 
foo1 will be rebuilt any time package foo2 is reconfigured."
puts "Does this package rely on another? Provide a comma seperated list."
$reliesOn = gets.chomp

# get optional dependsOn.
puts "Definition dependsOn: If package foo1 depends on package foo2, then package 
foo1 will be rebuilt any time package foo2 is rebuilt."
puts "Does this package optionally depend on another? Provide a comma seperated list."
$optDependsOn = gets.chomp

# get optional reliesOn.
puts "Definition reliesOn: If package foo1 relies on package foo2, then package 
foo1 will be rebuilt any time package foo2 is reconfigured."
puts "Does this package optionally rely on another? Provide a comma seperated list."
$optReliesOn = gets.chomp

# get hash check (get file location and run Digeost::SHA1.hexdigest(path)).
require 'digest/sha1'
$hash = "Empty"
if system("cd #{$SOURCES_REPOSITORY}; wget #{$srcUrl}")
	puts "DEBUG:  gonna run hash1 on #{$SOURCES_REPOSITORY}/#{$packageName}-#{$version}.tar.#{$compression}"
	$hash = Digest::SHA1.hexdigest("#{$SOURCES_REPOSITORY}/#{$packageName}-#{$version}.tar.#{$compression}")
else
	puts "Unable to determine digest hash, after first install attempt of this package you can find the hash in the journal."
end

# get license field.
$license = "GPL"

# get descriptions text.
puts "Provide a short description of the package."
$description = gets.chomp

##
# Generate pacakge file.
##
newPackage = open("#{$packageName.downcase}.rb", 'w')

newPackage.print <<EOF

#!/usr/bin/ruby -w

$LOAD_PATH.unshift '/var/lib/abt/'

require 'abtpackage'

##
# #{$packageName.downcase}.rb 
#
# #{$packageName.capitalize} package.
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

class #{$packageName.capitalize} < AbtPackage
  
protected
  
private
  
  $name         = "#{$packageName.capitalize}"
  $version      = "#{$version}"
  $srcDir       = "\#{$name.downcase}-\#{$version}"
  $srcFile      = "#{$srcFile}"
  $packageData  = {
    'name'              => $name,
    'execName'          => $name.downcase,
    'version'           => $version,
    'srcDir'            => $srcDir,
    'homepage'          => "#{$website}",
    'srcUrl'            => "#{$srcUrl}",
    'dependsOn'         => "#{$dependsOn}",
    'reliesOn'          => "#{$reliesOn}",
    'optionalDO'        => "#{$optDependsOn}",
    'optionalRO'        => "#{$optReliesOn}",
    'hashCheck'         => "#{$hash}",
    'patches'           => "",
    'patchesHashCheck'  => "",
    'mirrorPath'        => "",
    'license'           => "#{$license}",
    'description'       => "#{$description}"
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
EOF

puts "New package written to #{$packageName.downcase}.rb."
