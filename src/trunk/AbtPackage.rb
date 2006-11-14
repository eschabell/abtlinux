#!/usr/bin/ruby -w

##
# AbtPackage.rb 
#
# AbtPackage class provides an interface to AbtPackage creation within AbTLinux. By
# inheriting from this class (class Fortune < AbtPackage) one picks up all
# supported standard functions for the abt AbtPackage manager to make use of the
# new AbtPackage.
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
class AbtPackage
  
protected
  
private
  
public
  
  # the name of the package.
  attr_reader :name
  
  # the executable name for the package.
  attr_reader :execName
  
  # the package version number.
  attr_reader :version
  
  # the source directory for the package.
  attr_reader :srcDir
  
  # the packages homepage.
  attr_reader :homepage
  
  # the URL where this packages sources can be obtained.
  attr_reader :srcUrl
  
  # list of dependsOn (DO) related package dependencies.
  attr_reader :dependsOn
  
  # list of reliesOn (RO) related package dependencies.
  attr_reader :reliesOn
  
  # list of optional reliesOn (oRO) related package dependencies.
  attr_reader :optionalDO

  # list of optional dependsOn (oDO) related package dependencies.
  attr_reader :optionalRO
  
  # security hash value of package sources.
  attr_reader :hashCheck
  
  # list of available patches for this package.
  attr_reader :patches
  
  # security hash value of this packages patches.
  attr_reader :patchesHashCheck
  
  # available mirrors for this package.
  attr_reader :mirrorPath
  
  # type of license this package has.
  attr_reader :licence
  
  # the package description.
  attr_reader :description
    
    
  ##
  # Constructor for an AbtPackage, requires all the packge details.
  #
  # <b>PARAM</b> <i>Hash</i> - hash containing all package data.
  #
  ##
  def initialize( data )
    @name = data['name']
    @execName = data['execName']
    @version = data['version']
    @srcDir = data['srcDir']
    @homepage = data['homepage']
    @srcUrl = data['srcUrl']
    @dependsOn = data['dependsOn']
    @reliesOn = data['reliesOn']
    @optionalDO = data['optionalDO']
    @optionalRO = data['optionalRO']
    @hashCheck = data['hashCheck']
    @patches = data['patches']
    @patchesHashCheck = data['patchesHashCheck']
    @mirrorPath = data['mirrorPath']
    @license = data['license']
    @description = data['description']
  end
		
  ##
  # Provides all the data needed for this AbtPackage.
  #
  # <b>RETURNS:</b>  <i>hash</i> - Contains all AbtPackage attributes (constants).
  ##
  def details
		return {
			"name" 							=> @name,
			"execName"					=> @execName,
			"version"						=> @version,
			"srcDir"						=> @srcDir,
			"homepage"					=> @homepage,
			"srcUrl"						=> @srcUrl,
			"dependsOn"					=> @dependsOn,
			"reliesOn"					=> @reliesOn,
			"optionalDO"				=> @optionalDO,
			"optionalRO"				=> @optionalRO,
			"hashCheck"					=> @hashCheck,
			"patches"						=> @patches,
			"patchesHashCheck"	=> @patchesHashCheck,
			"mirrorPath"				=> @mirrorPath,
			"license"						=> @license,
			"description"				=> @description
		}
  end
  
  ##
  # Preliminary work will happen here such as downloading the tarball, 
  # unpacking it, downloading and applying patches.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if completes sucessfully, otherwise false.
  ##
  def pre
  end
  
  ##
  # Here we manage the ./configure step (or equivalent). We need to give ./configure 
  # (or autogen.sh, or whatever) the correct options so files are to be placed later in the 
  # right directories, so doc files and man pages are all in the same common location, etc. 
  # Don't forget too that it's here where we interact with the user in case there are optionnal 
  # dependencies.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def configure
  end
  
  ##
  # Here is where the actual builing of the software starts, for example running 'make'.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def build
  end
  
  ##
  # Any actions needed before the installation can occur will happen here, such as creating
  # new user accounts, dealing with existing configuration files, etc.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def preinstall
  end

  ##
  # All files to be installed are installed here.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def install
  end
  
  ##
  # Last bits of installation. adding the service for automatic start in init.d for example.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def post
  end
end
