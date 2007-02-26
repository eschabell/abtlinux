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
  
  ##
  # Unpacks this packages source file into the standard build location.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def unpackSources
    srcFile			= File.basename( @srcUrl )
    sourcesToUnpack = "#{$SOURCES_REPOSITORY}/#{srcFile}"
    unpackTool		= ""
    
    # check for existing file in source repo.
    if ( !File.exist?( sourcesToUnpack ) )
      return false
    end
    
    # check if possible existing sources in build directory.
    if ( File.directory?( "#{$BUILD_LOCATION}/#{@srcDir}" ) )
      return true
    end
    
    # determine which supported compression used [gz, tar, tgz, bz2, zip].
    compressionType = srcFile.split( '.' )
    
    case compressionType.last
      
    when "gz"
      unpackTool = "tar xzvf"
      
    when "tar"
      unpackTool = "tar xvf"
      
    when "bz2"
      unpackTool = "tar xjvf"
      
    when "tgz"
      unpackTool = "tar xzvf"
      
    when "zip"
      unpackTool = "unizp"
      
    else
      # unsupported format.
      return false
    end
    
    # DEBUG:
    #logger = AbtLogManager.new
    #logger.logToJournal( "DEBUG: unpack tool will be '#{unpackTool}'." )
    
    Dir.chdir( $BUILD_LOCATION )
    if ( !system( "#{unpackTool} #{sourcesToUnpack}" ) )
      return false
    end
    
    return true
  end
  
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
    @name             = data['name']
    @execName         = data['execName']
    @version          = data['version']
    @srcDir           = data['srcDir']
    @homepage         = data['homepage']
    @srcUrl           = data['srcUrl']
    @dependsOn        = data['dependsOn']
    @reliesOn         = data['reliesOn']
    @optionalDO       = data['optionalDO']
    @optionalRO       = data['optionalRO']
    @hashCheck        = data['hashCheck']
    @patches          = data['patches']
    @patchesHashCheck = data['patchesHashCheck']
    @mirrorPath       = data['mirrorPath']
    @license          = data['license']
    @description      = data['description']
  end
  
  ##
  # Provides all the data needed for this AbtPackage.
  #
  # <b>RETURNS:</b>  <i>hash</i> - Contains all AbtPackage attributes (constants).
  ##
  def details
    return {
      "Package name"    => @name,
      "Executable"		=> @execName,
      "Version"			=> @version,
      "Source location"	=> @srcDir,
      "Homepage"		=> @homepage,
      "Source uri"		=> @srcUrl,
      "Depends On"		=> @dependsOn,
      "Relies On"		=> @reliesOn,
      "Optional DO"		=> @optionalDO,
      "Optional RO"		=> @optionalRO,
      "Security hash"	=> @hashCheck,
      "Patches"			=> @patches,
      "Patches hash"	=> @patchesHashCheck,
      "Mirror"			=> @mirrorPath,
      "License"			=> @license,
      "Description"		=> @description
    }
  end
  
  ##
  # Preliminary work will happen here such as downloading the tarball,
  # unpacking it, downloading and applying patches.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if completes sucessfully, otherwise false.
  ##
  def pre
    downloader = AbtDownloadManager.new
    
    # download sources.
    if ( !downloader.retrievePackageSource( @name.downcase, $SOURCES_REPOSITORY ) )
      return false
    end
    
    # unpack sources.
    if ( !self.unpackSources )
      return false
    end
    
    # TODO: retrieve patches?
    # TODO: apply patches?
    
    return true
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
    Dir.chdir( "#{$BUILD_LOCATION}/#{@srcDir}" )
    
    # TODO: not some better way to deal with this than system and tee?
    if ( !system( "./configure --prefix=#{$DEFAULT_PREFIX} | tee #{$PACKAGE_INSTALLED}/#{@srcDir}.configure" ) )
      puts "DEBUG: [AbtPackage.configure] - configure section failed."
      return false
    end
    
    puts "DEBUG: [AbtPackage.configure] - configure section completed!"
    return true
  end
  
  ##
  # Here is where the actual builing of the software starts, for example running 'make'.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def build
    Dir.chdir( "#{$BUILD_LOCATION}/#{@srcDir}" )
    
    # TODO: not some better way to deal with this than system and tee?
    if( !system( "make | tee #{$PACKAGE_INSTALLED}/#{@srcDir}.build" ) )
      puts "DEBUG: [AbtPackage.build] - build section failed."
      return false
    end
    
    puts "DEBUG: [AbtPackage.build] - build section completed!"
    return true
  end
  
  ##
  # Any actions needed before the installation can occur will happen here, such as creating
  # new user accounts, dealing with existing configuration files, etc.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def preinstall
    # TODO: create_group?
    # TODO: create_user?
    return true;
  end
  
  ##
  # All files to be installed are installed here.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def install
    # TODO: implement.
    Dir.chdir( "#{$BUILD_LOCATION}/#{@srcDir}" )
    
    # TODO: can this be done without installwatch?
    if( !system( "installwatch --transl=no --backup=no --exclude=/dev,/proc,/tmp,/var/tmp,/usr/src,/sys --logfile=/tmp/#{@srcDir}.watch make install" ) )
      puts "DEBUG: [AbtPackage.install] - install section failed."
      # TODO: rollback any installed files (use install log).
      return false
    end
    
    puts "DEBUG: [AbtPackage.install] - install section completed!"
    return true
  end
  
  ##
  # Last bits of installation. adding the service for automatic start in init.d for example.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def post
    # TODO: implement me!
    return true
  end
  
  ##
  # Cleans up this packages source build directory.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, otherwise false.
  ##
  def removeBuild
    if ( $REMOVE_BUILD_SOURCES )
      buildSourcesLocation = "#{$BUILD_LOCATION}/#{srcDir}"
      
      if ( !File.directory?( buildSourcesLocation ) )
        return true
      end
      
      if ( !FileUtils.rm_rf buildSourcesLocation, :verbose => true  )
        return false
      end
    end
    
    return true
  end
end
