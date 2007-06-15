#!/usr/bin/ruby -w

##
# AbtLogManager.rb
#
# AbtLogManager class handles all aspects of logging and access to existing logs
# within the AbTLinux system.
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
class AbtLogManager
  
  protected
  
  private
  
  ##
  # Returns the path to given packages install log.
  # 
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>String</i> - Full path to install log.
  ##
  def getLog( package, type )
    require "packages/#{package}"
    sw         = eval( "#{package.capitalize}.new" )
    details    = sw.details
    
    case type
      
      when 'install'
        log = "#{$PACKAGE_INSTALLED}/#{details['Source location']}" + 
          "/#{details['Source location']}.install"
      
      when 'integrity'
        log = "#{$PACKAGE_INSTALLED}/#{details['Source location']}" + 
          "/#{details['Source location']}.integrity"
          
      when 'tmpinstall'
        log = "#{$ABT_TMP}/#{details['Source location']}.watch"

      when 'build'
        log = "#{$PACKAGE_INSTALLED}/#{details['Source location']}" + 
          "/#{details['Source location']}.build"
          
      else
        log = ""
        
    end        
        
    return log
  end


  public
  
  ##
  # Constructor for the AbtLogManager. It ensures all needed logs paths are
  # initialized.
  #
  #
  # <b>RETURN</b> <i>AbtLogManager</i> - an initialized AbtLogManager object.
  ##
  def initialize
    [$ABT_LOGS, $ABT_CACHES, $ABT_STATE, $BUILD_LOCATION, $PACKAGE_INSTALLED,
    $PACKAGE_CACHED, $ABT_TMP, $SOURCES_REPOSITORY].each { |dir|
      
      if ( ! File.directory?( dir ) )
        FileUtils.mkdir_p( dir )
        self.logToJournal( "Created directory: #{dir}." )
      end
    }
  end
  
  ##
  # Provides logging of the integrity of all installed files for the given
  # package. Will be called as part of the logging done during the install
  # phase.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if integrity log created successfully,
  # otherwise false.
  ##
  def logPackageIntegrity( package )
    #require "packages/#{package}"
    #sw = eval( "#{package.capitalize}.new" )
    #details = sw.details
    
    # our log locations.
    installLog = getLog( package, 'install' )
    integrityLog = getLog( package, 'integrity' )
    
    # get the installed files from the tmp file
    # into our install log.
    if ( File.exist?( installLog ) )
      installFile   = open( installLog, 'r' )
      integrityFile = open( integrityLog, 'w' )

      # get the integrity for each file, initially just permissions.      
      IO.foreach( installLog ) do |line|
        status = File.stat( line.chomp )
        octal  = sprintf( "%o", status.mode )
        integrityFile.puts "#{line.chomp}:#{octal}"
      end
      
      installFile.close
      integrityFile.close
    else
      return false  # no install log!
    end
    
    return true;
  end
  
  ##
  # Provides logging of all files installed by given package. Should be called
  # as part of the install phase of the build.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if install log created successfully,
  # otherwise false.
  ##
  def logPackageInstall( package )
    # some dirs we will not add to an install log.
    excluded_pattern = 
      Regexp.new( "^(/dev|/proc|/tmp|/var/tmp|/usr/src|/sys)+" )
    badLine = false  # used to mark excluded lines from installwatch log.
    
    # our log locations.
    installLog = getLog( package, 'install' )
    tmpInstallLog = getLog( package, 'tmpinstall' )
    
    # get the installed files from the tmp file
    # into our install log.
    if ( File.exist?( tmpInstallLog ) )
      installFile = open( installLog, 'w')
      
      # include only the file names from open calls
      # and not part of the excluded range of directories.
      IO.foreach( tmpInstallLog ) do |line|
        if ( line.split[1] == 'open' )
          if ( line.split[2] =~ excluded_pattern )
            #self.logToJournal( "DEBUG: Found bad logLine!" )
            badLine = true
          else
            badLine = false
          end
          
          if ( !badLine )
            #self.logToJournal( "DEBUG: adding line to installFile!")
            installFile.puts line.split[2]
          end
        end 
      end
      
      installFile.close
    end
    
    return true;
  end
  
  ##
  # Provides logging of all output produced during the build phase of the
  # given package. Should be called as part of the install phase of the build.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if build log created successfully,
  # otherwise false.
  ##
  def logPackageBuild( package )
    buildLog = getLog( package, 'build' )
    
    # make sure the build file exists.
    if ( !File.exist?( buildLog ) )
      return false
    end
    
    return true
  end
  
  ##
  # Provides a complete log of the given packages build. Includes everything
  # needed to duplicate the build at a later date.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if package cache created successfully,
  # otherwise false.
  ##
  def cachePackage( package )
    system = AbtSystemManager.new
    
    if ( system.packageInstalled( package ) )
      require "packages/#{package}"
      sw       = eval( "#{package.capitalize}.new" )
      details  = sw.details
      
      # TODO: collect package source.
      FileTest::exists?("#{$PACKAGE_INSTALLED}/#{details['Source location']}" + 
      "/#{details['Source location']}.install" )
      # TODO: collect package install log. 
      
      # TODO: collect package build log. 
      
      # TODO: collect package configure log. 
      
      # TODO: collect package integrity log.
      
      # TODO: collect package description (class file).
      
      # TODO: tar and bzip this directory (package-cache-version.tar.bz2) 
      
      return false # for now, once imlemented, need true
    end
    
    return false  # package not installed, can't cache it.
  end
  
  ##
  # Provides logging of given message to the AbTLinux journal. Message logged
  # with date timestamp.
  #
  # <b>PARAM</b> <i>String</i> - Message to be added to the log.
  #
  # <b>RETURN</b> <i>boolean</i> True if logged, otherwise false.
  ##
  def logToJournal( message )
    if ( log = File.new( $JOURNAL, "a+" ) )
      log.puts "#{$TIMESTAMP} : #{message}"
      log.close
      return true
    end
    
    return false
  end
end
