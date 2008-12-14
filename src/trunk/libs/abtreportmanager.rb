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
  def show_package_details(package)
    require "#{$PACKAGE_PATH}/#{package}"
    
    if (package = eval("#{package.capitalize}.new"))
      details = package.details
      
      puts "|====================================="
      puts "| Package name\t: #{details['Package name']}"
      details.delete("Package name")
      puts "| Version\t: #{details['Version']}"
      details.delete("Version")
      puts "| Homepage\t: #{details['Homepage']}"
      details.delete("Homepage")
      puts "| Executable\t: #{details['Executable']}"
      details.delete("Executable")
      puts "| Source uri\t: #{details['Source uri']}"
      details.delete("Source uri")
      puts "| Description\t: #{details['Description']}"
      details.delete("Description")
      puts "|====================================="
      puts "|====================================="
      
      details.each do |name, value|
        print "| #{name}\t"
        
        if (name.length < 14)
          print "\t"
        end
        
        puts ": #{value}"
      end
      
      puts "|====================================="
      return true
    end
    
    logger.debug("[AbtReportManger::showPackageDetails] - failed to show details for ${package}.")
    return false
  end
  
  ##
  # Display all packages installed and tracked by AbTLinux.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_installed_packages
    logger = Logger.new($JOURNAL)
    an_error_occurred = false    # set if something is incorrect in the state of an installed package.
		time_offset_position = 2     # position in array where time offset is to be removed.
    
    if (Dir.entries($PACKAGE_INSTALLED) - [ '.', '..' ]).empty?
      puts "\nNo AbTLinux packages are listed as installed, is your #{$PACKAGE_INSTALLED} empty?\n\n"
    else
      puts "\nInstalled AbTLinux packages:\n\n"
      puts "Package \t Version \t Installed"
			puts "========================================================="

			Dir.chdir($PACKAGE_INSTALLED)
      Dir.foreach($PACKAGE_INSTALLED) { |package| 
        if package != "." && package != ".."
          if File.exist?("#{$PACKAGE_INSTALLED}/#{package}/#{package}.install")
						# display package and version and then clean out offset from  timestamp.
						name_array = package.split('-')
						print name_array[0]
						if package.split('-')[0].length > 7
							print "\t"
						else
							print "\t\t"
						end
						name_array.shift   # remove first item, as already printed.
						name_array.each { |item| print "#{item}" }
						print "\t\t "
						time = "#{File.stat("#{$PACKAGE_INSTALLED}/#{package}/#{package}.install").ctime}".split
						time.each{ |element| print "#{element} " if time.index(element) != time.length - time_offset_position }
						puts "\n"
          else
            logger.error("[show_installed_packages] : #{package} missing install file, while entry exists in installed state.")
            an_error_occurred = true
          end
        end
      }
      puts "\n"
    end
    
    puts "*** From abt : please see the journal for information about installation state inconsistancies. ***" if an_error_occurred
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
  def show_package_log(package, log_type)
    system = AbtSystemManager.new
    logger = AbtLogManager.new
    
    # just return if package log file type is not installed, up to 
    # caller to message the user about why.
    if File.exists?(logger.get_log(package, log_type))
    	File.open(logger.get_log(package, log_type)).each { |line| puts line }
    end
  end
  
  ##
  # Display a list of the packages found in the frozen list.
  #
  # <b>RETURN</b> <i>hash</i> - a hash of the frozen packages, keys are package
  # names and values are the frozen timestamps.
  ##
  def show_frozen_packages

		# determine if there are frozen pacakges.
    frozen_hash = Hash.new  # has for values found.
    
    if (Dir.entries($PACKAGE_INSTALLED) - [ '.', '..' ]).empty?
      return Hash.new   # empty hash, no entries.
    else
      Dir.foreach($PACKAGE_INSTALLED) { |package| 
        if (package != "." && package != "..")
          # split the installed entry into two parts,
          # the package name and the version number.
          #package_array = package.split("-")
          #package_name  = package_array[0]
          
          # check for frozen log file.
          if (File.exist?(File.join($PACKAGE_INSTALLED, package, "frozen.log")))
						# dump packgae + frozen.log timestamp in package_hash.
						begin
							file = File.new(File.join($PACKAGE_INSTALLED, package, "frozen.log"), "r")
							#while (line = file.gets)
							line = file.gets
								frozen_hash = frozen_hash.merge(Hash[ "#{package}" => "#{line}" ])
							#end
							file.close
						rescue => error
							puts "Exception: #{error}"
							return false
						end
          end
        end
      }
    end

    return frozen_hash 
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
  def show_package_dependencies(package)
      require "#{$PACKAGE_PATH}/#{package}"

    if (package = eval("#{package.capitalize}.new"))
      details = package.details
    
      puts "|====================================="
      puts "| Package name\t\t: #{details['Package name']}"
      puts "| Version\t\t: #{details['Version']}"
      puts "|====================================="
      puts "|====================================="
      
      if details['Depends On'].empty? && details['Relies On'].empty? && 
        details['Optional DO'].empty? && details['Optional RO'].empty?
        puts "| No dependencies listed for this package."
      else
        puts "| Depends On\t\t: #{details['Depends On']}" if !details['Depends On'].empty?
        puts "| Relies On\t\t: #{details['Relies On']}" if !details['Relies On'].empty?
        puts "| Optional Depends On\t: #{details['Optional DO']}" if !details['Optional DO'].empty?
        puts "| Optional Relies On\t: #{details['Optional RO']}" if !details['Optional RO'].empty?
      end
      
      puts "|====================================="
      return true
    end

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
    # TODO: implement this.
    return false
  end
  
  ##
  # Display the AbTLinux journal file.
  #
  # <b> PARAM</b> <i>string</i> The complete path of the file to display.
  #
  # <b>RETURN</b> <i>iboolean</i> True if journal shown, otherwise false.
  ##
  def show_journal(file_name)
    if (File.exist?(file_name))
      puts "\n\n"
      puts "AbTLinux log:"
      puts "============="
      log = IO.readlines(file_name)
      log.each{ |entry| puts entry }
      puts "\n\n"
    else
      puts "\n\n"
      puts "AbtLinux log (#{File.basename(file_name)}) " + 
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
  def show_file_owner(file)
    # TODO: implement this.
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
  def search_package_descriptions(search_text)
    package_hash            = Hash.new  # has for values found.
    
    if (Dir.entries($PACKAGE_INSTALLED) - [ '.', '..' ]).empty?
      return package_hash   # empty hash, no entries.
    else
      Dir.foreach($PACKAGE_INSTALLED) { |package| 
        if (package != "." && package != "..")
					# split the installed entry into two parts,
          # the package name and the version number.
          package_array = package.split("-")
          package_name  = package_array[0]
          
          # check for match to name and description if the package file exists.
          if (File.exist?("#{$PACKAGE_PATH}/#{package_name}.rb"))
            require "#{$PACKAGE_PATH}/#{package_name}" 
            sw = eval("#{package_name.capitalize}.new")
            
            # add if matches name or description entries.
            matches_array = sw.description.scan(search_text)
            matches_array = matches_array.concat(package_name.scan(search_text))
            
            if matches_array.length > 0 
              # matches description so add it to hash.
              package_hash = package_hash.merge(Hash[ "#{package}" => "#{sw.description}" ])
            end
          end
        end
      }
    end

    # finished search results.
    return package_hash 
  end
  
  ##
  # Displays the contents of the current queue based on the given queue.
  #
  # <b>PARAM</b> <i>String</i> - the type of queue to display such as install
  # queue.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def show_queue(queue_type)
    
    case queue_type
      
    when "install"
      if (File.exist?(File.join($ABT_LOGS, "#{queue_type}.queue")))
        puts "\n\n"
        puts "AbTLinux #{queue_type} queue:"
        puts "======================="
        queue = IO.readlines(File.join($ABT_LOGS, "#{queue_type}.queue"))
        queue.each{ |entry| puts entry }
        puts "\n\n"
      else
        puts "\n\n"
        puts "AbtLinux  #{queue_type} is empty at this time."
        puts "\n\n"
      end
    else
      puts "#{queue_type.capitalize} is not an AbTLinux queue."
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
  def show_updates(target)
    # TODO: implement this.
    return false
  end
  
  ##
  # Generates an HTML page of installed packages from installed packages list.
  #
  # <b>RETURN</b> <i>void.</i>
  ##
  def generate_HTML_package_listing
    # TODO: implement this.
    return false
  end  
end
