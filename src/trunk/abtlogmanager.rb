#!/usr/bin/ruby -w

##
# abtlogmanager.rb
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

  public
  
  ##
  # Returns the path to given packages install log.
  # 
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>String</i> - Full path to install log.
  ##
  def get_log( package, type )
    require "#{$PACKAGE_PATH}#{package}"
    sw         = eval( "#{package.capitalize}.new" )
    details    = sw.details
    
    case type
      
      when 'install'
        log = "#{$PACKAGE_INSTALLED}/#{details['Source location']}/#{details['Source location']}.install"
      
      when 'integrity'
        log = "#{$PACKAGE_INSTALLED}/#{details['Source location']}/#{details['Source location']}.integrity"
          
      when 'tmpinstall'
        log = "#{$ABT_TMP}/#{details['Source location']}.watch"

      when 'build'
        log = "#{$PACKAGE_INSTALLED}/#{details['Source location']}/#{details['Source location']}.build"
          
      when 'configure'
        log = "#{$PACKAGE_INSTALLED}/#{details['Source location']}/#{details['Source location']}.configure"

      else
        log = ""
        
    end        
        
    return log
  end
  
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
        to_journal( "Created directory: #{dir}." )
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
  def log_package_integrity( package )
    #require "#{$PACKAGE_PATH}#{package}"
    #sw = eval( "#{package.capitalize}.new" )
    #details = sw.details
    
    # our log locations.
    installLog = get_log( package, 'install' )
    integrityLog = get_log( package, 'integrity' )
    
    # get the installed files from the tmp file
    # into our install log.
    if ( File.exist?( installLog ) )
      installFile   = open( installLog, 'r' )
      integrityFile = open( integrityLog, 'w' )

      # get the integrity for each file, initially just permissions.      
      IO.foreach( installLog ) do |line|
        status = File.stat( line.chomp )
        octal  = sprintf( "%o", status.mode )
        integrityFile << "#{line.chomp}:#{octal}\n"
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
  def log_package_install( package )
    # some dirs we will not add to an install log.
    excluded_pattern = Regexp.new( "^(/dev|/proc|/tmp|/var/tmp|/usr/src|/sys)+" )
    badLine = false  # used to mark excluded lines from installwatch log.
    
    # our log locations.
    installLog = get_log( package, 'install' )
    tmpInstallLog = get_log( package, 'tmpinstall' )
    
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
            #self.to_journal( "DEBUG: adding line to installFile!")
            installFile << "#{line.split[2]}\n"
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
  def log_package_build( package )
    buildLog = get_log( package, 'build' )
    
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
  def cache_package( package )
    system = AbtSystemManager.new
    
    if ( system.package_installed( package ) )
      sw           = eval( "#{package.capitalize}.new" )
      cachedDir    = $PACKAGE_CACHED + "/" + sw.srcDir
      sourcePath   = $SOURCES_REPOSITORY + "/" + File.basename( sw.srcUrl )
      sourceFile   = File.basename( sw.srcUrl )
      installLog   = get_log( package, 'install' )
      buildLog     = get_log( package, 'build' )
      configureLog = get_log( package, 'configure' )
      integrityLog = get_log( package, 'integrity' )
      packageFile  = "#{$PACKAGE_PATH}#{package}.rb"
      
      
      FileUtils.mkdir_p( cachedDir )

      # collect package source.
      if ( FileTest::exist?( sourcePath ) )
        FileUtils.copy_file( sourcePath, "#{cachedDir}/#{sourceFile}" )
        puts "\nCaching copy of #{package} source."
      else
        puts "\nUnable to cache copy of #{package} source."
      end
        
      # collect package install log. 
      if ( FileTest::exist?( installLog ) )
        FileUtils.copy_file( installLog, "#{cachedDir}/#{sw.srcDir}.install" )
        puts "\nCaching copy of #{package} install log."
      else
        puts "\nUnable to cache copy of #{package} install log."
      end
      
      # collect package build log. 
      if ( FileTest::exist?( buildLog ) )
        FileUtils.copy_file( buildLog, "#{cachedDir}/#{sw.srcDir}.build" )
        puts "\nCaching copy of #{package} build log."
      else
        puts "\nUnable to cache copy of #{package} build log."
      end
      
      # collect package configure log. 
      if ( FileTest::exist?( configureLog ) )
        FileUtils.copy_file( configureLog, "#{cachedDir}/#{sw.srcDir}.configure" )
        puts "\nCaching copy of #{package} configure log."
      else
        puts "\nUnable to cache copy of #{package} configure log."
      end

      # collect package integrity log.
      if ( FileTest::exist?( integrityLog ) )
        FileUtils.copy_file( integrityLog, "#{cachedDir}/#{sw.srcDir}.integrity" )
        puts "\nCaching copy of #{package} integrity log."
      else
        puts "\nUnable to cache copy of #{package} integrity log."
      end
      
      # collect package description (class file).
      if ( FileTest::exist?( packageFile ) )
        FileUtils.copy_file( packageFile, "#{cachedDir}/#{package}.rb" )
        puts "\nCaching copy of #{package} package description."
      else
        puts "\nUnable to cache copy of #{package} package description, from location #{packageFile}"
      end
      
      # tar and bzip this directory (package-cache-version.tar.bz2) 
      Dir.chdir( $PACKAGE_CACHED )
      if ( system( "tar -cf #{sw.srcDir}.tar #{sw.srcDir}" ) &&
            system( "bzip2 -f #{sw.srcDir}.tar" ) )
        # last but not least, remove our tarball directory
        FileUtils.rm_rf( cachedDir )
        return true
      end
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
  def to_journal( message )
    if ( log = File.new( $JOURNAL, "a+" ) )
      log << "#{$TIMESTAMP} : #{message}\n"
      log.close
      return true
    end
    
    return false
  end
end
