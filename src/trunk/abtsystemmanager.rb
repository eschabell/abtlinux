#!/usr/bin/ruby -w

##
# abtsystemmanager.rb
#
# AbtSystemManager class handles all aspects of the AbTLinux system. It takes
# care of such tasks as cleanup, fixing, verification and management of
# settings within the system.
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
class AbtSystemManager
  
  protected
  
  private
  
  ##
  # Determines if given file is in given directory.
  # 
  # <b>PARAM</b> <i>String</i> - directory path to search.
  # <b>PARAM</b> <i>String</i> - entry we are looking for in given directory.
  #
  # <b>RETURN</b> <i>boolean</i> - True if entry found in given directory, 
  # otherwise false.
  ##
  def found_entry( directory, name )
    Find.find( directory ) do |path|
      
      Find.prune if [".", ".."].include? path
      case name
        when String
          return true if File.basename( path ) == name
      else
        raise ArgumentError
      end
      
    end
    
    return false  # match not found.  
  end
  
  public
  
  ##
  # Constructor for the System manager
  #
  # <b>RETURN</b> <i>AbtSystemManager</i> - an initialized 
  # AbtSystemManager object.
  ##
  def initialize
  end
  
  ##
  # Removes all sources for packages that are not currently installed. Makes
  # use of install listing to determine package sources to keep.
  #
  # <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
  # false.
  ##
  def cleanup_package_sources
    return false
  end
  
  ##
  # All logs for packages not in install list are cleaned off the system.
  #
  # <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
  # false.
  ##
  def cleanup_logs
    return false
  end
  
  ##
  # Checks if files from given package install list are actually installed.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if no installed files are missing, 
  # otherwise false.
  ##
  def verify_installed_files( package )
    logger = AbtLogManager.new
    system = AbtSystemManager.new
    
    if !system.package_installed( package )
      logger.to_journal( "Unable to verify installed files for #{package}, it's not installed!")
      return false
    end
    
    if !File.exist?( logger.get_log( package, 'install' ) )
      logger.to_journal( "Unable to verify installed files for #{package}, installed package but install log missing!" ) 
      return false
    end
    
    failure = false  # marker after checking all files to determine failure.
    File.open( logger.get_log( package, "install" ) ).each { |line| 
      if !File.exist?( line.chomp )
        logger.to_journal( "The file : #{line.chomp} is missing for #{package}." )
        failure = true
      end
    }
    return false if failure
    
    # all files passed check.
    return true
  end
  
  ##
  # Checks if given packages installed symlinks are broken or missing.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if no symlinks found missing 
  # or broken, otherwise false.
  ##
  def verify_symlinks( package )
    return false
  end
  
  ##
  # Checks the given packages dependencies for missing or broken dependencies.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if dependencies intact, otherwise
  # false.
  ##
  def verify_package_depends( package )
    return false
  end
  
  ##
  # Checks the given packages installed files against the integrity log for
  # changes to installed files.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>hash</i> - Empty hash if no problems found, otherwise
  # hash of problem files and their encountered errors.
  ##
  def verify_package_integrity( package )
    return false
  end
  
  ##
  # Fixes the given package.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
  # false.
  ##
  def fix_package( package )
    return false
  end
  
  ##
  # Sets the URI of a central repository for pre-compiled packages.
  #
  # <b>PARAM</b> <i>String</i> - the URI where the central repository is
  # located.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the URI is set, otherwise false.
  ##
  def set_central_repo( uri )
    return false
  end
  
  ##
  # Sets the location where the package tree is to be downloaded from, can be
  # set to a local location.
  #
  # <b>PARAM</b> <i>String</i> - the location of the package tree.
  #
  # <b>RETURN</b> <i>boolean</i> - True if the package tree location is set,
  # otherwise false.
  ##
  def set_package_tree_location( location )
    return false
  end
    
  ##
  # Checks if the given package is installed by checking for entry in the
  # installed directory.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if package installed, otherwise
  # false.
  ##
  def package_installed( package )
    require "#{$PACKAGE_PATH}#{package}"
    sw = eval( "#{package.capitalize}.new" )
    details = sw.details
    
    if ( found_entry( $PACKAGE_INSTALLED, sw.srcDir ) )
      return true
    end
     
    return false
  end
 
end
