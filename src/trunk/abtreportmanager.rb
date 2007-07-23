#!/usr/bin/ruby -w

##
# abtreportmanager.rb
#
# AbtReportManager class handles all sort of report and query generation within
# the AbTLinux system.
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
class AbtReportManager
    
  protected
  
  private
  
  public
  
  ##
  # Constructor for the AbtReportManager.
  #
  # <b>RETURN</b> <i>AbtReportManager</i> - an initialized 
  # Report1Manager object.
  ##
  def initialize
  end
  
  ##
  # Display all data for a given package.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if completes without error, 
  # otherwise false.
  ##
  def show_package_details( package )
    require "#{$PACKAGE_PATH}#{package}"
    
    if ( package = eval( "#{package.capitalize}.new" ) )
      details = package.details
      
      puts "|====================================="
      puts "| Package name\t: #{details['Package name']}"
      details.delete( "Package name" )
      puts "| Version\t: #{details['Version']}"
      details.delete( "Version" )
      puts "| Homepage\t: #{details['Homepage']}"
      details.delete( "Homepage" )
      puts "| Executable\t: #{details['Executable']}"
      details.delete( "Executable" )
      puts "| Source uri\t: #{details['Source uri']}"
      details.delete( "Source uri" )
      puts "| Description\t: #{details['Description']}"
      details.delete( "Description" )
      puts "|====================================="
      puts "|====================================="
      
      details.each do |name, value|
        print "| #{name}\t"
        
        if ( name.length < 14 )
          print "\t"
        end
        
        puts ": #{value}"
      end
      
      puts "|====================================="
      return true
    end
    
    logger.to_journal( "[AbtReportManger::showPackageDetails] - failed to show details for ${package}." )
    return false
  end
  
  ##
  # Display all packages installed and tracked by AbTLinux.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_installed_packages
    if ( Dir.entries( $PACKAGE_INSTALLED ) - [ '.', '..' ] ).empty?
      puts "\nNo AbTLinux packages are listed as installed, is your #{$PACKAGE_INSTALLED} empty?\n\n"
    else
      puts "\nInstalled AbTLinux packages:"
      puts "============================"
      Dir.foreach( $PACKAGE_INSTALLED ) { |package| puts package if package != "." && package != ".." }
      puts "\n"
    end
  end
  
  ##
  # Display the contents of the requested log for a given package. Possible
  # log types are; configure, install, build and integrity. This method will return nothing
  # if the package log is not installed.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>PARAM</b> <i>String</i> - log type.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_package_log( package, logType )
    system = AbtSystemManager.new
    logger = AbtLogManager.new
    
    # just return if package not installed, up to 
    # caller to message the user about why.
    if !system.package_installed( package )
      return
    end
    
    File.open( logger.get_log( package, logType ) ).each { |line| puts line }
  end
  
  ##
  # Display a list of the packages found in the frozen list.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_frozen_packages
    return false
  end
  
  ##
  # Provides access to dependency checking via the AbTLinux DepEngine. (This
  # portal to the DepEngine will be expanded in apart sub-project, more
  # details at a later date.)
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>hash</i> - Empty hash if no problems found, otherwise
  # hash of problem files and their encountered errors.
  ##
  def show_package_dependencies( package )
    return false
  end
  
  ##
  # Display all files not part of any installed AbTLinux package. This
  # delivers a list of files that are not tracked by AbTLinux package
  # management.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_untracked_files
    return false
  end
  
  ##
  # Display the AbTLinux journal file.
  #
  # <b> PARAM</b> <i>string</i> The complete path of the file to display.
  #
  # <b>RETURN</b> <i>iboolean</i> True if journal shown, otherwise false.
  ##
  def show_journal( fileName )
    if ( File.exist?( fileName ) )
      puts "\n\n"
      puts "AbTLinux log:"
      puts "============="
      log = IO.readlines( fileName )
      log.each{ |entry| puts entry }
      puts "\n\n"
    else
      puts "\n\n"
      puts "AbtLinux log ( #{File.basename( fileName )} ) " + 
           "is empty at this time."
      puts "\n\n"
    end
    
    return true
  end
  
  ##
  # Display the name of the package(s) that own the given file.
  #
  # <b>PARAM</b> <i>String</i> - a file name.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_file_owner( file )
    return false
  end
  
  ##
  # Searches the installed package trees package descriptions for matching
  # occurrances of the given search text.
  #
  # <b>PARAM</b> <i>String</i> - a search text.
  #
  # <b>RETURN</b> <i>hash</i> - a hash of the search results, keys are package
  # names and values are matching descriptions.
  ##
  def search_package_descriptions( searchText )
    packageHash = Hash.new  # has for values found.
    
    # TODO: get packages installed list
    if ( Dir.entries( $PACKAGE_INSTALLED ) - [ '.', '..' ] ).empty?
      return packageHash   # empty hash, no entries.
    else
      Dir.foreach( $PACKAGE_INSTALLED ) { |package| 
        if ( package != "." && package != "..")
          # split the installed entry into two parts,
          # the package name and the version number.
          packageArray = package.split( "-" )
          packageName  = packageArray[0]
          
          # check for match to name and description if the package file exists.
          if ( File.exist?( "#{$PACKAGE_PATH}#{packageName}.rb" ) )
            require "#{$PACKAGE_PATH}#{packageName}" 
            sw = eval( "#{packageName.capitalize}.new" )
            
            # add if matches name or description entries.
            matchesArray = sw.description.scan( searchText )
            matchesArray = matchesArray.concat( packageName.scan( searchText ) )
            
            if ( matchesArray.length > 0 )
              # matches so add to hash.
              packageHash = packageHash.merge( Hash[ "#{package}" => "#{sw.description}" ] )
            end
          end
        end
      }
    end

    # finished search results.
    return packageHash 
  end
  
  ##
  # Displays the contents of the current queue based on the given queue.
  #
  # <b>PARAM</b> <i>String</i> - the type of queue to display such as install
  # queue.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_queue( queueType )
    
    case queueType
      
    when "install"
      if ( File.exist?( "#{$ABT_LOGS}/#{queueType}.queue" ) )
        puts "\n\n"
        puts "AbTLinux #{queueType} queue:"
        puts "======================="
        queue = IO.readlines( "#{$ABT_LOGS}/#{queueType}.queue" )
        queue.each{ |entry| puts entry }
        puts "\n\n"
      else
        puts "\n\n"
        puts "AbtLinux  #{queueType} is empty at this time."
        puts "\n\n"
      end
    else
      puts "#{queueType.capitalize} is not an AbTLinux queue."
    end
  end
  
  ##
  # Reports available updates for a given package or package tree based on the
  # current system.
  #
  # <b>PARAM</b> <i>String</i> - the target of the update check, either a
  # package name or a package tree name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
  # false.
  ##
  def show_updates( target )
    return false
  end
  
  ##
  # Generates an HTML page of installed packages from installed packages list.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def generate_HTML_package_listing
    return false
  end  
end
