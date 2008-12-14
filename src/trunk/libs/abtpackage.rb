#!/usr/bin/ruby -w

##
# abtpackage.rb
#
# AbtPackage class provides an interface to AbtPackage creation within
# AbTLinux. By inheriting from this class (class Fortune < AbtPackage) one 
# picks up all supported standard functions for the abt AbtPackage manager
# to make use of the new AbtPackage.
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
  # <b>RETURNS:</b> <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def unpack_sources
    src_file			= File.basename(@srcUrl)
    sources_to_unpack = File.join($SOURCES_REPOSITORY, src_file)
    unpack_tool		= ""
    
    # check for existing file in source repo.
    if (!File.exist?(sources_to_unpack))
      return false
    end
    
    # check if possible existing sources in build directory.
    if (File.directory?("#{$BUILD_LOCATION}/#{@srcDir}"))
      return true
    end
    
    # determine which supported compression used [gz, tar, tgz, bz2, zip].
    compression_type = src_file.split('.')
    
    case compression_type.last
      
    when "gz"
      unpack_tool = "tar xzvf"
      
    when "tar"
      unpack_tool = "tar xvf"
      
    when "bz2"
      unpack_tool = "tar xjvf"
      
    when "tgz"
      unpack_tool = "tar xzvf"
      
    when "zip"
      unpack_tool = "unizp"
      
    else
      # unsupported format.
      return false
    end
        
    Dir.chdir($BUILD_LOCATION)
		output = `#{unpack_tool} #{sources_to_unpack}`
		exitcode = $?.exitstatus
    if (exitcode != 0)
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
  def initialize(data)
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
  # <b>RETURNS:</b>  <i>hash</i> - Contains all AbtPackage 
  # attributes (constants).
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
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if completes sucessfully, 
  # otherwise false.
  ##
  def pre(verbose=true)
    downloader = AbtDownloadManager.new
    
    # download sources.
    if (!downloader.retrieve_package_source(@name.downcase, $SOURCES_REPOSITORY))
      return false
    end
    
    # validate sources sha1.
    if (!downloader.validated(@hashCheck, File.join($SOURCES_REPOSITORY, File.basename(@srcUrl))))
      return false
    end
    
    # unpack sources.
    if (!unpack_sources)
      return false
    end
    
    # ensure we have an installed directory to use.
    if (! File.directory?(File.join($PACKAGE_INSTALLED, @srcDir)))
      FileUtils.mkdir_p(File.join($PACKAGE_INSTALLED, @srcDir))
    end
    
    # TODO: implement pre section retrieve patches?
    # TODO: implement pre section apply patches?
    
    return true
  end
  
  ##
  # Here we manage the ./configure step (or equivalent). We need 
  # to give ./configure (or autogen.sh, or whatever) the correct options 
  # so files are to be placed later in the right directories, so doc files 
  # and man pages are all in the same common location, etc.
  # Don't forget too that it's here where we interact with the user in 
  # case there are optionnal dependencies.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def configure(verbose=true)
    cmd = "./configure --prefix=#{$BUILD_PREFIX} --sysconfdir=#{$BUILD_SYSCONFDIR} --localstatedir=#{$BUILD_LOCALSTATEDIR} --mandir=#{$BUILD_MANDIR} --infodir=#{$BUILD_INFODIR}" 
    verbose_redirect = "| tee #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.configure"
    silent_redirect = "> #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.configure 2>&1"

    # if we chain commands with pipe for verbose is true, then want to get
    # the configure command exit status with the following.
    verbose_results = %x/exit ${PIPESTATUS[0]}/
    
    # setup command.
    if verbose
      command = "#{cmd} #{verbose_redirect}; #{verbose_results}"
      puts "DEBUG verbose: #{command}"
    else
      command = "#{cmd} #{silent_redirect}"
      puts "DEBUG not verbose: #{command}"
    end

    Dir.chdir(File.join($BUILD_LOCATION, @srcDir))

    # set our optimizations before configuring.
    $cflags   = "CFLAGS=" + '"' + $BUILD_CFLAGS + '"'
    puts "Using the following optimizations:  export #{$cflags}\n"

    # now start to configure.
    if !system("export #{$cflags}; export CXXFLAGS='${CFLAGS}'")
      puts "[AbtPackage.configure] - configure section failed trying to export #{$cflags}, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "DEBUG: exported our flags fine!"

    if !system(command)
      puts "[AbtPackage.configure] - configure section failed, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "[AbtPackage.configure] - configure section completed, exit code was #{$?.exitstatus}!" if (verbose)
    return true
  end
  
  ##
  # Here is where the actual builing of the software starts, 
  # for example running 'make'.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def build(verbose=true)
    cmd = "make"
    verbose_redirect = "| tee #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.build"
    silent_redirect = "> #{$PACKAGE_INSTALLED}/#{@srcDir}/#{@srcDir}.build 2>&1"

    # if we chain commands with pipe for verbose is true, then want to get
    # the configure command exit status with the following.
    verbose_results = %x/exit ${PIPESTATUS[0]}/    
    
    # setup command.
    if verbose
	    cmd = "#{cmd} #{verbose_redirect}; #{verbose_results}"
    else
	    cmd = "#{cmd} #{silent_redirect}"
    end


    Dir.chdir(File.join($BUILD_LOCATION, @srcDir))
    
    if !system(cmd)
      puts "[AbtPackage.build] - build section failed, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "[AbtPackage.build] - build section completed, exit code was #{$?.exitstatus}!" if (verbose)
    return true
  end
  
  ##
  # Any actions needed before the installation can occur will happen here, 
  # such as creating new user accounts, dealing with existing configuration 
  # files, etc.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def preinstall(verbose=true)
    # TODO: preinstall section create_group?
    # TODO: preinstall section create_user?
    return true;
  end
  
  ##
  # All files to be installed are installed here.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def install(verbose=true)
    if (verbose)
      command = "installwatch --transl=no --backup=no " +
          "--exclude=/dev,/proc,/tmp,/var/tmp,/usr/src,/sys " +
          "--logfile=#{$ABT_TMP}/#{@srcDir}.watch make install"
    else
      command = "installwatch --transl=no --backup=no " +
          "--exclude=/dev,/proc,/tmp,/var/tmp,/usr/src,/sys " +
          "--logfile=#{$ABT_TMP}/#{@srcDir}.watch make install >/dev/null"
    end 
  
    Dir.chdir(File.join($BUILD_LOCATION, @srcDir))
    
    if !system(command)
      puts "[AbtPackage.install] - install section failed, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "[AbtPackage.install] - install section completed, exit code was #{$?.exitstatus}!" if (verbose)
    return true
  end
  
  ##
  # Last bits of installation. adding the service for automatic 
  # start in init.d for example.
  #
  # <b>PARAM</b> <i>boolean</i> - true if you want to see the verbose output,
  # otherwise false. Defaults to true.
  # 
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def post(verbose=true)
    if (verbose)
      command = "ldconfig"
    else
      command = "ldconfig >/dev/null"
    end 
  
    if !system(command)
      puts "[AbtPackage.post] - post section failed trying to run ldconfig, exit code was #{$?.exitstatus}."
      return false
    end
    
    puts "[AbtPackage.post] - post section completed run of ldconfig, exit code was #{$?.exitstatus}!" if (verbose)
    return true
  end
  
  ##
  # Cleans up this packages source build directory.
  #
  # <b>RETURNS:</b>  <i>boolean</i> - True if the completes sucessfully, 
  # otherwise false.
  ##
  def remove_build
    puts "Removings build..."
    if ($REMOVE_BUILD_SOURCES)
      build_sources_location = File.join($BUILD_LOCATION, srcDir)
      
      if (!File.directory?(build_sources_location))
        return true
      end
      
      if (!FileUtils.rm_rf build_sources_location, :verbose => true )
        return false
      end
    end
 
    return true
  end
end
