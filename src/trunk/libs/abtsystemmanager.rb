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
  def found_entry(directory, name)
    Find.find(directory) do |path|
      
      Find.prune if [".", ".."].include? path
      case name
        when String
          return true if File.basename(path) == name
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
  # <b>PARAM</b> <i>Boolean</i> - if false then removal of taballs done silently, default is 
  # true and removes with verbose output.
  # 
  # <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
  # false.
  ##
  def cleanup_package_sources(verbose=true)
    logger       = Logger.new($JOURNAL)
    sourcesArray = Array.new
    
    if (Dir.entries($PACKAGE_INSTALLED) - [ '.', '..' ]).empty?
      FileUtils.remove Dir.glob("#{$SOURCES_REPOSITORY}/*"), :verbose => verbose, :force => true
      logger.info("Cleanup of package sources done, encountered an empty installation listing?")
      return true
    else
      Dir.foreach($PACKAGE_INSTALLED) { |package| 
        if (package != "." && package != "..")
          # split the installed entry into two parts,
          # the package name and the version number.
          packageArray = package.split("-")
          packageName  = packageArray[0]
          
          # create an array of installed package tarball names.
          if (File.exist?("#{$PACKAGE_PATH}#{packageName}.rb"))
            require "#{$PACKAGE_PATH}#{packageName}" 
            sw = eval("#{packageName.capitalize}.new")
            sourcesArray.push(File.basename(sw.srcUrl))
          end
        end
      }
    end

    if (Dir.entries($SOURCES_REPOSITORY) - [ '.', '..' ]).empty?
      logger.info("Cleanup of package sources done, encountered an empty sources repository?")
      return false
    else
      if (verbose)
        puts "\nRemoving the following source files:"
        puts "===================================="
      end

      Dir.foreach($SOURCES_REPOSITORY) { |file| FileUtils.remove("#{$SOURCES_REPOSITORY}/#{file}", :verbose => verbose, :force => true) if (file != "." && file != ".." && !sourcesArray.include?(file)) }
      
      if (verbose)
        puts "====================================\n"
      end
    end

    return true
  end
  
  ##
  # Checks if files from given package install list are actually installed.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if no installed files are missing, 
  # otherwise false.
  ##
  def verify_installed_files(package)
    logger = Logger.new($JOURNAL)
    # TODO: refactor myLogger:
    myLogger = AbtLogManager.new
    
    if !package_installed(package)
      logger.info("Unable to verify installed files for #{package}, it's not installed!")
      return false
    end
    
    if !File.exist?(myLogger.get_log(package, 'install'))
      logger.info("Unable to verify installed files for #{package}, installed package but install log missing!") 
      return false
    end
    
    failure = false  # marker after checking all files to determine failure.
    File.open(myLogger.get_log(package, "install")).each { |line| 
      if !File.exist?(line.chomp)
        logger.info("The file : #{line.chomp} is missing for #{package}.")
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
  def verify_symlinks(package)
    # TODO: implement this.
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
  def verify_package_depends(package)
    # TODO: implement this.
    return false
  end
  
  ##
  # Checks the given packages installed files against the integrity log for
  # changes to installed files.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>hash</i> - Empty hash if no problems found, otherwise
  # hash of problem files and their encountered errors. Hash has keys of 
  # file names and the values are the package name and the problem detected. 
  ##
  def verify_package_integrity(package)
    require "#{$PACKAGE_PATH}/#{package}"
    sw = eval("#{package.capitalize}.new")
    
    # TODO: refactor myLogger.
    myLogger = AbtLogManager.new
    logger   = Logger.new($JOURNAL)
    integrityHash = Hash.new  # holds files failing interity check.
            
    if !File.exist?("#{$PACKAGE_INSTALLED}/#{sw.srcDir}/#{sw.srcDir}.integrity")
      logger.info("Unable to check file integrity for #{package}, integrity log missing!") 
      return integrityHash   # empty hash, no entries.
    else
          
      # FIXME: pickup each integrity file and check each entry (filename integrityvalue)
      File.open(myLogger.get_log(package, "integrity")).each { |line|
      
        # seperate the filepath and integrity value.
        lineArray = line.split(':')
        
        # check for existing file.
        if !File.exist?(lineArray[0].chomp)
          logger.info("The file : #{lineArray[0].chomp} is missing for #{package}.")

          # any failure or discrepency is added to hash: file => package + problem
          integrityHash = integrityHash.merge(Hash[ lineArray[0].chomp => "#{package} - file missing." ])
        end
        
        # passed existence check, now integrity check, need to ensure
        # value computed matches our logged octal results. This requires
        # computing the results, converting to octal, then chop off the 
        # first char by reversing the string and chopping the last (is
        # there a better way?) char and then reversing those results.
        octalResults = '%07o' % File.lstat(lineArray[0].chomp).mode
        
        if lineArray[1].chomp != octalResults.reverse.chop.reverse
          # any failure or discrepency is added to hash: file => package + problem
          integrityHash = integrityHash.merge(Hash[ file => "#{package} #{sw.description}" ])  
        end
      }      
    end
  
    return integrityHash
  end
  
  ##
  # Fixes the given package.
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if completes without error, otherwise
  # false.
  ##
  def fix_package(package)
    # TODO: implement this.
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
  def set_central_repo(uri)
    # TODO: implement this.
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
  def set_package_tree_location(location)
    # TODO: implement this.
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
  def package_installed(package)
    require "#{$PACKAGE_PATH}/#{package}"
    sw = eval("#{package.capitalize}.new")
    
    if (found_entry("#{$PACKAGE_INSTALLED}/#{sw.srcDir}", "#{sw.srcDir}.install"))
      return true
    end
     
    return false
  end
 
	##
  # Checks if the given package is frozen by checking for entry in the
  # installed directory (frozen.log file).
  #
  # <b>PARAM</b> <i>String</i> - Package name.
  #
  # <b>RETURN</b> <i>boolean</i> - True if package installed, otherwise
  # false.
  ##
  def package_frozen(package)
    require "#{$PACKAGE_PATH}/#{package}"
    sw = eval("#{package.capitalize}.new")
    
		# looking for frozen log file.
    if (found_entry("#{$PACKAGE_INSTALLED}/#{sw.srcDir}", "frozen.log"))
      return true
    end
     
    return false
  end
 
end
