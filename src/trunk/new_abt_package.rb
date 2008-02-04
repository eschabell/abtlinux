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
  
# get name of package.
puts "What is the packages name?"
$packageName = gets.chomp

# get version.
puts "What is the version number of this package?"
$version = gets.chomp

# get source file name.
puts "What is the source file name (like grep-1.2.1.tar.bz2)?"
$srcFile = gets.chomp

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

# get hash check (get file location and run Digest::SHA1.hexdigest(path)).
puts "Provide the complete path to and existing copy of the source tarball."
$localPath = gets.chomp
require 'digest/sha1'
$hash = "#{Digest::SHA1.hexdigest($localPath)}"

# get license field.
puts "Enter the license type (GPL, Apache, etc)."
$license = gets.chomp

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
  $srcDir       = "#{$packageName.downcase}-#{$version}"
  $srcFile      = "#{$srcFile}"
  $packageData  = {
    'name'              => "#{$packageName.downcase}",
    'execName'          => "#{$packageName.downcase}",
    'version'           => "#{$version}",
    'srcDir'            => "#{$packageName.downcase}-#{$version}",
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
